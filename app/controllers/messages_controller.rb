class MessagesController < ApplicationController
	before_action :authenticate_user!, :set_conversation
	include ActionView::Helpers::TextHelper
	PER_PAGE = 15

	def index
		last_page = (@conversation.messages.count.to_f / PER_PAGE).ceil
		if @conversation.messages.count > 0
			@messages = @conversation.messages.paginate(page: params[:page] ||
				last_page , per_page: PER_PAGE)

			my_id = current_user.id
			conversation_id = @conversation.id

				# Обновляет статусы входящих сообщений для себя на прочитанные
			MessageStatus.where(user_id: my_id, status: 0)
				.includes(:message).where(messages: {conversation_id: conversation_id})
				.where.not(messages: {sender_id: my_id}).each do |status|
					status.update_attributes(status: 1)
			end

	  	@conversation.users.each do |user|

					# Обновляет статусы входящих сообщений для отправителей на прочитанные
	  		unless user == current_user
	  			MessageStatus.where(user_id: user.id, status: 0)
	  				.includes(:message).where(messages: {conversation_id: conversation_id,
	  					sender_id: user.id}).each do |status|
	  				status.update_attributes(status: 1)
	  			end
	  		end

					# Обновляет у всех отправителей входящих сообщений
					# в открытом диалоге свои сообщения на прочтенные
	  		ActionCable.server.broadcast "messages_user_#{user.id}",
		      read_messages: true,
		      sender_id: user.id unless user.id == my_id

	  			# Обновляет открытые в данный момент списки диалогов у всех участников диалога
	  		message_status = 
	  			@conversation.messages.last.message_statuses.where(user_id: user.id)[0].try(:status) || 
	  			@conversation.messages.last.status
	  		con_s = @conversation.messages.last.sender_id == user.id ? '' : message_status
				ActionCable.server.broadcast "conversations_user_#{user.id}",
		  		update: true,
		  		conversation_id: conversation_id,
		  		conversation_status: con_s,
		  		message_status: message_status	  		
	  	end

	  		# Обновляет у текущего пользователя количество входящих сообщений в шапке
	    ActionCable.server.broadcast "notifications_user_#{current_user.id}",
	    	type: 'update',
	    	messages: helpers.unread_messages

	    	# Обновляет вид статуса входящих сообщений у себя
		  ActionCable.server.broadcast "messages_user_#{my_id}",
	      read_incoming: true,
	      me: current_user.id

	  else

	  	@messages = @conversation.messages

		end

		@message = Message.new

	end

	def create
		@message = @conversation.messages.build(message_params)
		@message.sender_id = current_user.id
		@conversation.updated_at = Time.now
    if @message.save
    		# Присваивает статус непрочитанного сообщения для всех пользователей
			@conversation.users.each do |user|
				@message.message_statuses.create(user_id: user.id, status: 0)
			end

				# Добавляет сообщение пользователям в открытый диалог
      ActionCable.server.broadcast "messages_#{@conversation.id}",
        message: simple_format(@message.body),
        status: 'unread', # @message.status,
        created_at: helpers.time_for_messages(@message.created_at), # time_for_messages
        user_path: user_path(User.find(@message.sender_id)),
        avatar: view_context.image_path(User.find(@message.sender_id).avatar_url(:thumb)),
        sender_name: User.find(@message.sender_id).first_name,
        sender_id: @message.sender_id,
        conversation_id: @conversation.id
      # head :ok

    	sender = User.find(@message.sender_id)

    		# Обновляет открытые в данный момент списки диалогов у всех участников диалога 
	    if @conversation.save
	    		# Т.к. получателей может быть несколько, для иконки диалога для отправителя
	    		# берется человек, сообщение которого последнее перед сообщением отправителя.
	    		# Для остальных пользователей для иконки диалога берется сам отправитель
	    	if @conversation.messages.where.not(sender_id: sender.id).last
	    		recipient = User.find(@conversation.messages.where.not(sender_id: sender.id)
	    		.last.sender_id)
	    	else
	    		recipient = @conversation.users.where.not(id: current_user.id)[0]
	    	end

	    	@conversation.users.each do |user|
    			interlocutors = []
    			@conversation.users.each do |current_user|
    				interlocutors << current_user.full_name unless current_user == user 
    			end

	    		message_status = 
		  			@message.message_statuses.where(user_id: user.id)[0].status || @message.status

	    		if user == sender
	    			conversation_status = ''
	    			interlocutor_path = user_path(recipient)
	    			interlocutor_avatar = view_context.image_path(recipient.avatar_url(:thumb))
	    		else
	    			conversation_status = message_status
	    			interlocutor_path = user_path(sender)
	    			interlocutor_avatar = view_context.image_path(sender.avatar_url(:thumb))
	    		end

		    	ActionCable.server.broadcast "conversations_user_#{user.id}",
		    		conversation_id: @conversation.id,
		    		conversation_status: conversation_status,
		    		interlocutor_path: interlocutor_path,
		    		interlocutor_avatar: interlocutor_avatar,
		    		interlocutor_name: "Conversation with " + interlocutors.join(", "),
		    		conversation_path: conversation_messages_path(@conversation),
		    		message_time: helpers.time_for_messages(@message.created_at),
		    		message_status: message_status,
		    		sender_name: sender.first_name,
		    		message_body: truncate(@message.body, length: 50)

	    	end
	    end

	    	# Уведомление о новом сообщении для всех получателей
	    @conversation.users.each do |user|
		    ActionCable.server.broadcast "notifications_user_#{user.id}",
		    	type: 'new_message',
		    	conversation_id: @conversation.id unless sender == user	
	    end

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
