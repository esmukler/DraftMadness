class UpdatePlayInSchools < ApplicationJob
  def perform(custom_date_string = nil)
    @date_string = calculate_date(custom_date_string)
    resp = RestClient.get(cbs_scoreboard_url)

    fail unless resp.code.between?(200, 299)

    parse_site(resp.body)
    return 'Play In Schools updated'
  end

  def calculate_date(custom_date_string)
    if custom_date_string
      begin
         Date.parse(custom_date_string)
         return custom_date_string
      rescue Date::Error
      end
    end
    todays_date = Date.today
    return todays_date.strftime("%Y%m%d")
  end


  def cbs_scoreboard_url
    "https://www.cbssports.com/college-basketball/scoreboard/#{@date_string}"
  end

  def parse_site(resp_body)
    doc = Nokogiri::HTML(resp_body)
    completed_games = doc.css('.single-score-card.postgame')
    puts "#{completed_games.length} games completed on this date"

    completed_games.each do |game_div|
      team_divs = game_div.css('tbody tr')[0..1]

      play_in_school, in_order = find_play_in_schools(team_divs)
      next unless play_in_school
      puts "Play In School updating: #{play_in_school.name}"

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
