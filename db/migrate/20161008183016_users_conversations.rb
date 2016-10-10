class UsersConversations < ActiveRecord::Migration
  def change
  	create_join_table :users, :conversations
  end
end
