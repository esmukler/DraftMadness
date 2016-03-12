module ApplicationHelper
  def my_owner_page?
    controller_name == 'owners' &&
      action_name == 'show' &&
      current_user.owners.include?(@owner)
  end
end
