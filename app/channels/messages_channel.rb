class MessagesChannel < ApplicationCable::Channel  
  def subscribed
    stream_from "messages_#{params[:conversation]}"
  end

  def read_messages(data)
    conversation = Conversation.find(data['conversation_id'])
  	conversation.messages.where(recipient_id: data['recipient_id']).update_all(status: 1)
  	ActionCable.server.broadcast "messages_#{data['conversation_id']}",
      read_all: true,
      recipient_id: data['recipient_id']

  	sender = User.find(conversation.messages.last.sender_id) 
  	recipient = User.find(conversation.messages.last.recipient_id)
  	ActionCable.server.broadcast "conversations_user_#{sender.id}",
  		update: true,
  		conversation_id: conversation.id,
  		conversation_status: '',
  		message_status: conversation.messages.last.status
  	ActionCable.server.broadcast "conversations_user_#{recipient.id}",
  		update: true,
  		conversation_id: conversation.id,
  		conversation_status: conversation.messages.last.status,
  		message_status: conversation.messages.last.status

  end
end