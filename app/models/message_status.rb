class MessageStatus < ApplicationRecord
	enum status: [:unread, :read]
	belongs_to :user
	belongs_to :message
end
