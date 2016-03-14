class AddIndicesOnOwnerSchools < ActiveRecord::Migration
  def change
    add_index :owner_schools, :school_id
    add_index :owner_schools, :owner_id
    add_index :owner_schools, [:school_id, :owner_id]
    add_index :owner_schools, [:school_id, :league_id]
  end
end
