class HomepagesController < ApplicationController
  before_action :authenticate_user!

  def root
  end
end