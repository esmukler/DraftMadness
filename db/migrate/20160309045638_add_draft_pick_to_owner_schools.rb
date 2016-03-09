class AddDraftPickToOwnerSchools < ActiveRecord::Migration
  def change
    add_column :owner_schools, :draft_pick, :integer, null: false
  end
end
