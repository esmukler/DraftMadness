class AddYearToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :year, :integer
  end
end
