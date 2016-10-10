class AddDefaultValueToStatusForMessages < ActiveRecord::Migration
  def change
  	change_column :messages, :status, :integer, default: 0
  end
end
