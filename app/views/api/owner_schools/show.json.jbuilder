json.os @owner_school
json.school do
  json.id     @owner_school.school.id
  json.region @owner_school.school.region
end
json.current_owner_turn @owner.current_turn?
