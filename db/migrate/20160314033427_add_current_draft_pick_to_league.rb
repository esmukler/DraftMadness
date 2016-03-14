class AddCurrentDraftPickToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :current_draft_pick, :integer, null: false, default: 1
  end
end
