class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string  :name,            null: false
      t.string  :mascot
      t.string  :primary_color,   null: false, default: '#000000'
      t.string  :secondary_color, null: false, default: '#fff'
      t.integer :seed_id,         null: false

      t.timestamps
    end
  end
end
