json.league do
  json.id                 @league.id
  json.current_draft_pick @league.current_draft_pick
end


json.current_owner do
  json.id       @current_owner.id
  json.user_id  @current_owner.user_id
  json.turn     @league.turn_for?(@current_owner)
  json.regions  @current_owner.selected_regions
end
