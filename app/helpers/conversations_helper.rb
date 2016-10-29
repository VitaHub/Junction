module ConversationsHelper
	def name(conversation)
		Conversation.find(conversation.id).users.each do |user|
			unless user == current_user
				return "Conversation with #{user.first_name+' '+user.last_name}"
			end
		end
	end

	def interlocutor(conversation)
		Conversation.find(conversation.id).users.each do |user|
			unless user == current_user
				return user
			end
		end
	end

	def interlocutors(conversation)
		interlocutors = []
		Conversation.find(conversation.id).users.each do |user|
			unless user == current_user
				interlocutors << user
			end
		end
		interlocutors
	end

	def conversation_name(conversation)
		'Conversation with ' + interlocutors(conversation).map { |user|  user.full_name }.join(', ')
	end
end
