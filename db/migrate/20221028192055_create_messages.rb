class CreateMessages < ActiveRecord::Migration[5.0]
  def up
    create_table :messages do |t|
      t.references :chat, foreign_key: true
      t.integer :message_number, null: false
      t.text :message_content

      t.timestamps
    end
    add_index :messages, :message_number
  end

  def down
    drop_table :messages, if_exists: true
  end
end
