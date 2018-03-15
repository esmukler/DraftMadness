class UpdatePlayInSchools < ApplicationJob
  def perform
    %w(13 14).each do |march_date|
      resp = RestClient.get(ncaa_scoreboard_url(march_date))

      fail unless resp.code.between?(200, 299)

      parse_site(resp.body)
    end
  end

  def ncaa_scoreboard_url(date)
    "https://www.ncaa.com/scoreboard/basketball-men/d1/2018/03/#{date}"
  end

  def parse_site(resp_body)
    doc = Nokogiri::HTML(resp_body)
    completed_games = doc.css('.game.final')
    completed_games.each do |game_div|
      team_divs = game_div.css(".linescore .linescore tr")[1..2]
      slugs = team_divs.map { |team_div| find_team_slug(team_div) }
      scores = team_divs.map { |team_div| find_final_score(team_div) }

      play_in_school, in_order = find_school_and_order_by_slugs(slugs)
      next unless play_in_school
      first_is_winner = determine_winner(scores, in_order)

      update_school_info(play_in_school, first_is_winner)
    end
  end

  def find_school_and_order_by_slugs(slugs)
    school = School.current.find_by(slug: slugs.join("/"))
    return [school, true] if school
    school = School.current.find_by(slug: slugs.reverse.join("/"))
    return [school, false] if school
    [nil, nil]
  end

  def find_team_slug(team_div)
    team_div.css(".school a").first.attributes["href"].value.gsub("/schools/","")
  end

  def find_final_score(team_div)
    team_div.css("td.final.score").first.text
  end

  def determine_winner(scores, in_order)
    scores.first > scores.last == in_order
  end

  def update_school_info(school, first_is_winner)
    names = school.name.split("/")
    mascots = school.mascot.split("/")
    slugs = school.slug.split("/")

    winner_name = names[first_is_winner ? 0 : 1]
    winner_mascot = mascots[first_is_winner ? 0 : 1]
    winner_slug = slugs[first_is_winner ? 0 : 1]

    school.update(name: winner_name, mascot: winner_mascot, slug: winner_slug)
    puts "updated:"
    puts [school.name, school.mascot, school.slug]
  end
end
