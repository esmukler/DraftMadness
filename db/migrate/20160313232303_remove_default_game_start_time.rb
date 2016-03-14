class RemoveDefaultGameStartTime < ActiveRecord::Migration
  def change
    change_column :games, :start_time, :datetime, null: true
  end
end
