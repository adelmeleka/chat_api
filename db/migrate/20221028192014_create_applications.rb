class CreateApplications < ActiveRecord::Migration[5.0]
  def up
    create_table :applications do |t|
      t.string :application_token, null: false
      t.string :name
      t.integer :chats_count, default: 0

      t.timestamps
    end

    add_index :applications, :application_token
  end

  def down
    drop_table :applications, if_exists: true
  end
end
