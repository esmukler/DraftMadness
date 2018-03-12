class AddSlugToSchools < ActiveRecord::Migration[5.0]
  def change
    add_column :schools, :slug, :string
    add_index :schools, :slug
  end
end
