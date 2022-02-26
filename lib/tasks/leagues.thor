class Leagues < Thor
  require './config/environment.rb'

  desc 'create_sim_league', 'Create a simulation league'
  def create_sim_league
    ActiveRecord::Base.transaction do
      commish = User.where(is_admin: true).first
      league = League.create(
        name: 'Sim League',
        description: 'This league was created to test stuff.',
        commissioner_id: commish.id,
        password: 'password'
      )

      league.owners.create(
        user_id: commish.id,
        team_name: "Commish's Team",
        motto: "I'm the best."
      )
      idx = 1
      current_year = Time.now.year
      until league.full? do
        user = User.create!(email: "sim_#{idx}_#{current_year}@example.com", password: 'password')
        puts "#{user.email} created"
        owner = user.owners.create!(team_name: "drafter_#{idx}", motto: "I'm the No. #{idx} best player", league: league)
        idx += 1
      end
    end
  end
end
