desc "This task fetches scores"
task :fetch_scores => :environment do
  FetchScores.perform_now
  puts "done"
end

# e.g. rake "update_play_in_schools[20250314]"
desc "This task updates the schools from the play-in games"
task :update_play_in_schools, [:date_string] => :environment do |t, args|
  puts "Updating play-in schools..."
  UpdatePlayInSchools.perform_now(args[:date_string])
  puts "done."
end
