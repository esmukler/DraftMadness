class CreateOwnerSchools < ActiveRecord::Migration
  def change
    create_table :owner_schools do |t|
      t.integer :owner_id,  null: false
      t.integer :school_id, null: false
      t.integer :draft_pick

      t.timestamps
    end
  end
end
