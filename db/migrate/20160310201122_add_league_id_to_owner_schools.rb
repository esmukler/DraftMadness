class AddLeagueIdToOwnerSchools < ActiveRecord::Migration
  def change
    add_column :owner_schools, :league_id, :integer, null: false
  end
end
