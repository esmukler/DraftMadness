class AddYearToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :year, :integer
  end
end
