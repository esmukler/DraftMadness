class UpdatePlayInSchools < ApplicationJob
  def perform
    resp = RestClient.get(cbs_scoreboard_url)

    fail unless resp.code.between?(200, 299)

    parse_site(resp.body)
  end

  def cbs_scoreboard_url
    todays_date = Date.today
    string_date = todays_date.strftime("%Y%m%d")
    "https://www.cbssports.com/college-basketball/scoreboard/#{string_date}"
  end

  def parse_site(resp_body)
    doc = Nokogiri::HTML(resp_body)
    completed_games = doc.css('.single-score-card.postgame')

    completed_games.each do |game_div|
      team_divs = game_div.css('tbody tr')[0..1]

      play_in_school, in_order = find_play_in_schools(team_divs)
      next unless play_in_school

      scores = team_divs.map { |team_div| find_final_score(team_div) }
      first_is_winner = determine_winner(scores, in_order)

      update_school_info(play_in_school, first_is_winner)
    end
  end

  def find_play_in_schools(team_divs)
    slugs = team_divs.map { |team_div| find_team_slug(team_div) }
    find_school_and_order_by_slugs(slugs)
  end

  def find_school_and_order_by_slugs(slugs)
    school = School.current.find_by(slug: slugs.join("/"))
    return [school, true] if school
    school = School.current.find_by(slug: slugs.reverse.join("/"))
    return [school, false] if school
    [nil, nil]
  end

  def find_team_slug(team_div)
    href = team_div.css('a').first.attributes['href'].value
    href.match(/college-basketball\/teams\/([\w]+)\//)[1]
  end

  def find_final_score(team_div)
    team_div.css('td')[-1].text
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
