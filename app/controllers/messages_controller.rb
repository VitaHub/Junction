class MessagesController < ApplicationController
	before_action :authenticate_user!, :set_conversation
	include ActionView::Helpers::TextHelper

	def index
		# per_page = 15
		# last_page = (@conversation.messages.count.to_f / per_page).ceil
		if @conversation.messages.count > 0
			@messages = @conversation.messages#.paginate(page: params[:page] || last_page , per_page: per_page)
	  	sender = User.find(@conversation.messages.last.sender_id) 
	  	recipient = User.find(@conversation.messages.last.recipient_id)
	  	ActionCable.server.broadcast "conversations_user_#{sender.id}",
	  		update: true,
	  		conversation_id: @conversation.id,
	  		conversation_status: '',
	  		message_status: @conversation.messages.last.status
	  	ActionCable.server.broadcast "conversations_user_#{recipient.id}",
	  		update: true,
	  		conversation_id: @conversation.id,
	  		conversation_status: @conversation.messages.last.status,
	  		message_status: @conversation.messages.last.status
	    ActionCable.server.broadcast "notifications_user_#{current_user.id}",
	    	type: 'update',
	    	messages: current_user.messages.unread.count
	  else
	  	@messages = @conversation.messages
		end
		@message = Message.new
		@conversation.messages.where(recipient_id: current_user.id).update_all(status: 1)

	  ActionCable.server.broadcast "messages_#{@conversation.id}",
      read_all: true,
      recipient_id: current_user.id,
      conversation_id: @conversation.id

	end

	def create
		@message = @conversation.messages.build(message_params)
		@message.sender_id = current_user.id
		recipient_id = @conversation.users.where.not(id: current_user.id)[0].id
		@message.recipient_id = recipient_id
		@conversation.updated_at = Time.now
    if @message.save
      ActionCable.server.broadcast "messages_#{@conversation.id}",
        message: simple_format(@message.body),
        status: @message.status,
        created_at: helpers.time_for_messages(@message.created_at), # time_for_messages
        user_path: user_path(User.find(@message.sender_id)),
        avatar: view_context.image_path(User.find(@message.sender_id).avatar.url(:thumb)),
        sender_name: User.find(@message.sender_id).first_name,
        recipient_id: @message.recipient_id,
        conversation_id: @conversation.id
      head :ok
    	@conversation.messages.where(recipient_id: current_user.id).update_all(status: 1)
	    if @conversation.save
	    	sender = User.find(@message.sender_id)
	    	recipient = User.find(@message.recipient_id)
	    	ActionCable.server.broadcast "conversations_user_#{sender.id}",
	    		conversation_id: @conversation.id,
	    		conversation_status: '',
	    		interlocutor_path: user_path(recipient),
	    		interlocutor_avatar: view_context.image_path(recipient.avatar.url(:thumb)),
	    		interlocutor_name: recipient.full_name,
	    		conversation_path: conversation_messages_path(@conversation),
	    		message_time: helpers.time_for_messages(@message.created_at),
	    		message_status: @message.status,
	    		sender_name: sender.first_name,
	    		message_body: truncate(@message.body, length: 50)
	    	ActionCable.server.broadcast "conversations_user_#{recipient.id}",
	    		conversation_id: @conversation.id,
	    		conversation_status: @message.status,
	    		interlocutor_path: user_path(sender),
	    		interlocutor_avatar: view_context.image_path(sender.avatar.url(:thumb)),
	    		interlocutor_name: sender.full_name,
	    		conversation_path: conversation_messages_path(@conversation),
	    		message_time: helpers.time_for_messages(@message.created_at),
	    		message_status: @message.status,
	    		sender_name: sender.first_name,
	    		message_body: truncate(@message.body, length: 50)
	    end
	    ActionCable.server.broadcast "notifications_user_#{recipient.id}",
	    	type: 'new_message',
	    	conversation_id: @conversation.id
    end

    respond_to do |format|
      format.html { redirect_to conversation_messages_path(@conversation) }
      format.js {head :ok}
    end
	end

		private

	def message_params
		params.require(:message).permit(:body)
	end

	def set_conversation
		@conversation = Conversation.find(params[:conversation_id])
		redirect_to conversations_path, alert: "Access denied!" if @conversation.users.where(id: current_user.id).empty?
	end
end
