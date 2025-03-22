desc "This task fetches scores"
task :fetch_scores, [:date_string] => :environment do |t, args|
  FetchScores.perform_now(args[:date_string])
  puts "done"
end

# e.g. rake "update_play_in_schools[20250314]"
desc "This task updates the schools from the play-in games"
task :update_play_in_schools, [:date_string] => :environment do |t, args|
  puts "Updating play-in schools..."
  UpdatePlayInSchools.perform_now(args[:date_string])
  puts "done."
end

# e.g. rake "update_game_times[20250322]"
desc "This task updates game times"
task :update_game_times, [:date_string] => :environment do |t, args|
  UpdateGameTimes.perform_now(args[:date_string])
  puts "done."
end
