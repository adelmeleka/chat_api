class CreateChats < ActiveRecord::Migration[5.0]
  def up
    create_table :chats do |t|
      t.references :application, foreign_key: true
      t.integer :chat_number, null: false
      t.integer :messages_count, default: 0

      t.timestamps
    end
    add_index :chats, :chat_number
  end

  def down
    drop_table :chats, if_exists: true
  end
end
