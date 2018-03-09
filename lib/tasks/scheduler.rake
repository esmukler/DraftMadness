desc "This task fetches scores"
task :fetch_scores => :environment do
  puts "Updating scores..."
  FetchScores.perform_now
  puts "done."
end
