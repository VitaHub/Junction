class MessagesController < ApplicationController
	before_action :authenticate_user!, :set_conversation
	# enable_sync only: [:create]

	def index
		@messages = @conversation.messages
		@message = Message.new
		@conversation.messages.where(recipient_id: current_user.id).update_all(status: 1)
		# sync_update @conversation.messages
	end

	def create
		@message = @conversation.messages.build(message_params)
		@message.sender_id = current_user.id
		recipient_id = @conversation.users.where.not(id: current_user.id)[0].id
		@message.recipient_id = recipient_id
		@conversation.updated_at = Time.now
    @conversation.save
    # if 
    	@message.save
    	@conversation.messages.where(recipient_id: current_user.id).update_all(status: 1)
    	# sync_update @conversation.messages
    	# sync_new @message
    # end

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
