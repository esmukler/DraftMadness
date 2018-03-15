desc "This task fetches scores"
task :fetch_scores => :environment do
  FetchScores.perform_now
  puts "done"
end

desc "This task updates the schools from the play-in games"
task :update_play_in_schools => :environment do
  puts "Updating play-in schools..."
  UpdatePlayInSchools.perform_now
  puts "done."
end
