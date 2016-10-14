class MessagesChannel < ApplicationCable::Channel  
  def subscribed
    stream_from "messages_#{params[:conversation]}"
  end

  def read_messages(data)
  	Conversation.find(data['conversation_id']).messages.where(recipient_id: data['recipient_id']).update_all(status: 1)
  	ActionCable.server.broadcast "messages_#{data['conversation_id']}",
      read_all: true,
      recipient_id: data['recipient_id']
  end
end