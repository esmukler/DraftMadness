class ExpandMottoForOwners < ActiveRecord::Migration
  def change
    change_column :owners, :motto, :text
  end
end
