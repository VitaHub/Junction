class ConversationsController < ApplicationController
	before_action :authenticate_user!

  def index
  	@conversations = current_user.conversations.order(updated_at: :desc)
  end

  def new
    @interlocutors = User.all.select { |user| user == current_user ? nil : user }
  end

  def create

    if params[:chat_room] && params[:interlocutors]
      interlocutors = params[:interlocutors]
      if interlocutors.size == 1
          # Ищет диалог ТОЛЬКО между собой и собеседеником
        conversations = current_user.conversations.includes(:users).where(users: {id: interlocutors[0]}).select { |c| c.users.count == 2 }
        if conversations.empty?
          @conversation = Conversation.new
          @conversation.users << current_user
          @conversation.users << User.find(interlocutors[0])
          @conversation.save
        else
          @conversation = conversations[0]
        end
      else
        @conversation = Conversation.new
        @conversation.users << current_user
        interlocutors.each do |i|
          @conversation.users << User.find(i)
        end
        @conversation.save
      end
    elsif params[:chat_room] && params[:interlocutors] == nil
      # render :new
      return
    else
        # Ищет диалог ТОЛЬКО между собой и собеседеником
    	conversations = current_user.conversations.includes(:users).where(users: {id: params[:recipient_id]}).select { |c| c.users.count == 2 }
    	if conversations.empty?
    		@conversation = Conversation.new
    		@conversation.users << current_user
    		@conversation.users << User.find(params[:recipient_id])
        @conversation.save
    	else
    		@conversation = conversations[0]
    	end
    end

    redirect_to conversation_messages_path(@conversation) if @conversation

  end

end
