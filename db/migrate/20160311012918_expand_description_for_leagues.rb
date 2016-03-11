class ExpandDescriptionForLeagues < ActiveRecord::Migration
  def change
    change_column :leagues, :description, :text
  end
end
