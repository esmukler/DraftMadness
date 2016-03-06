class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,    null: false
      t.string :password, null: false
      t.string :encrypted_password, null: false, default: '', limit: 128

      t.timestamps
    end
  end
end
