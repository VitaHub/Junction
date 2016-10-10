class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :recipient_id
      t.integer :sender_id
      t.integer :conversation_id
      t.text :body, null: false
      t.integer :status, null: false

      t.timestamps null: false
    end
  end
end
