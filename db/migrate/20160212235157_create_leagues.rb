class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string  :name,            null: false
      t.text    :description
      t.integer :commissioner_id
      t.string  :password

      t.timestamps
    end
  end
end
