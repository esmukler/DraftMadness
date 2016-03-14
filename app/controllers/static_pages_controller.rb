class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!

  def rules
  end

  def contact
  end
end
