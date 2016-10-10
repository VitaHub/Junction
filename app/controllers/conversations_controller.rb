class ConversationsController < ApplicationController
	before_action :authenticate_user!

  def index
  	@conversations = current_user.conversations.order(updated_at: :desc)
  end

  def create
  	conversations = current_user.conversations.includes(:users).where(users: {id: params[:recipient_id]})
  	if conversations.empty?
  		@conversation = Conversation.new
  		@conversation.users << current_user
  		@conversation.users << User.find(params[:recipient_id])
      @conversation.save
  	else
  		@conversation = conversations[0]
  	end

    redirect_to conversation_messages_path(@conversation)

  end

end
