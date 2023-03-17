class FetchScores < ApplicationJob
  def perform
    puts "fetching today's scores..."
    resp = RestClient.get(cbs_scoreboard_url)

    fail unless resp.code.between?(200, 299)

    parse_site(resp.body)
  end

  def cbs_scoreboard_url
    "https://www.cbssports.com/college-basketball/scoreboard/"
  end

  def parse_site(resp_body)
    doc = Nokogiri::HTML(resp_body)
    completed_games = doc.css('.single-score-card.postgame')

    completed_games.each do |game_div|
      team_divs = game_div.css('tbody tr')[0..1]

      schools = team_divs.map { |team_div| find_school(team_div) }
      next unless schools.compact.count == 2

      game = Game.find_by_schools(*schools)
      next unless game && game.needs_update?

      final_scores = team_divs.map { |team_div| find_final_score(team_div) }

      update_game(game, schools, final_scores)
    end
  end

  def find_school(team_div)
    slug = find_team_slug(team_div)
    School.current.find_by(slug: slug)
  end

  def find_team_slug(team_div)
    href = team_div.css('a').first.attributes['href'].value
    href.match(/college-basketball\/teams\/([\w]+)\//)[1]
  end

  def find_final_score(team_div)
    team_div.css('td')[-1].text
  end

  def update_game(game, schools, final_scores)
    puts "------updating game between #{schools.first.name} and #{schools.last.name}"
    winning_team_id = final_scores.first > final_scores.last ? schools.first.id : schools.last.id
    losing_team_id = final_scores.first > final_scores.last ? schools.last.id : schools.first.id

    score1 = schools.first.id == game.school1.id ? final_scores.first : final_scores.last
    score2 = schools.first.id == game.school1.id ? final_scores.last : final_scores.first

    game.update!(
      school1_score: score1.to_i,
      school2_score: score2.to_i,
      winning_team_id: winning_team_id,
      losing_team_id: losing_team_id,
      is_over: true
    )

    if game.next_game
      if game.id < game.other_previous_game.id
        game.next_game.update!(school1_id: winning_team_id)
      else
        game.next_game.update!(school2_id: winning_team_id)
      end
    end

    schools.each(&:break_cache!)
  end
end
