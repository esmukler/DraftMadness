class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string  :name,            null: false
      t.string  :description
      t.integer :commissioner_id, null: false
      t.string  :password,        null: false

      t.timestamps
    end
  end
end
