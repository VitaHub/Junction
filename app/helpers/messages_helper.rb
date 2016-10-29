module MessagesHelper
	def unread_messages
		current_user.message_statuses.unread.includes(:message)
			.where.not(messages: {sender_id: current_user.id}).count || 0
	end
end
