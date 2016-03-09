class AddHasPaidToOwners < ActiveRecord::Migration
  def change
    add_column :owners, :has_paid, :boolean, default: false, null: false
  end
end
