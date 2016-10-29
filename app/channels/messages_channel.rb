class MessagesChannel < ApplicationCable::Channel  
  def subscribed
    stream_from "messages_#{params[:conversation]}"
    stream_from "messages_user_#{current_user.id}"
  end

  def read_messages(data)

    conversation = Conversation.find(data['conversation_id'])
    sender_id = conversation.messages.last.sender_id
    users = [current_user, User.find(sender_id)]

    users.each do |user|
        # Обновляет в БД статус последнего сообщения отправителя
        # для отправителя и для себя
      conversation.messages
        .where(sender_id: sender_id)
        .last.message_statuses
        .where(user_id: user.id).update_all(status: 1)

        # Обновляет статус сообщения в открытом диалоге
      ActionCable.server.broadcast "messages_user_#{user.id}",
        read_messages: true,
        sender_id: sender_id
    end

      # Обновляет список диалогов для каждого участника разговора
    conversation.users.each do |user|
      message_status = 
          conversation.messages.last.message_statuses.where(user_id: user.id)[0].status || 
          @conversation.messages.last.status
      con_s = sender_id == user.id ? '' : message_status
      ActionCable.server.broadcast "conversations_user_#{user.id}",
        update: true,
        conversation_id: conversation.id,
        conversation_status: con_s,
        message_status: message_status 

    end

      # Обновляет у текущего пользователя количество входящих сообщений в шапке
    ActionCable.server.broadcast "notifications_user_#{current_user.id}",
      type: 'update',
      messages: current_user.message_statuses.unread.includes(:message)
        .where.not(messages: {sender_id: current_user.id}).count

  end

    # Уведомление о процессе печати в диалоге
  def typing(data)
    Conversation.find(data['conversation_id']).users.each do |user|
      unless current_user == user
        ActionCable.server.broadcast "messages_user_#{user.id}",
          typing: data['typing'],
          sender_name: current_user.full_name        
      end
    end
  end

end