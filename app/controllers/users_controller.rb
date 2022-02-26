class UsersController < ApplicationController
  def show
    @user = current_user
    @owners_by_league = @user.owners.old.order(created_at: :desc)
  end
end
