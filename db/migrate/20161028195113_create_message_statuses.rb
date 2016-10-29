class CreateMessageStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :message_statuses do |t|
      t.integer :user_id
      t.integer :message_id
      t.integer :status, null: false

      t.timestamps
    end
  end
end
