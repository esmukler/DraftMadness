class UpdateGameTimes < ApplicationJob
  def perform(date_string = nil)
    @date_string = date_string
    puts "updating game times from #{formatted_date}..."
    resp = RestClient.get(cbs_schedule_url)

    fail unless resp.code.between?(200, 299)

    update_times(resp.body)
  end

  private

  def formatted_date
    if @date_string
      Date.strptime(@date_string, "%Y%m%d").strftime("%B %d, %Y")
    else
      "today"
    end
  end

  def cbs_schedule_url
    "https://www.cbssports.com/college-basketball/schedule/NCAA/#{@date_string}"
  end

  def update_times(resp_body)
    doc = Nokogiri::HTML(resp_body)

    find_game_rows(doc).each do |game_row|
      team_divs = game_row.css('.TeamName')[0..1]

      schools = team_divs.map { |team_div| find_school(team_div) }
      next unless schools.compact.count == 2

      game = Game.find_by_schools(*schools)
      return unless game

      start_time = game_row.css('.CellGame a').text.strip

      update_time(game, start_time)
    end
  end

  def find_game_rows(doc)
    doc.css('.TableBase-table tr')
  end
  
  def find_school(team_div)
    slug = find_team_slug(team_div)
    School.current.find_by(slug: slug)
  end

  def find_team_slug(team_div)
    href = team_div.css('a').first.attributes['href'].value
    href.match(/college-basketball\/teams\/([A-Z]+)\//)[1]
  end

  def update_time(game, start_time)
    date = @date_string || Date.today.strftime('%Y%m%d')
    
    if start_time.upcase == "TBA"
      puts "Game time is TBA - skipping update"
      return
    end

    pacific_time = convert_to_pacific_time(date, start_time)
    
    if game.update!(start_time: pacific_time)
      puts "updated Game #{game.id} to #{pacific_time} (Pacific Time)"
    else
      puts "failed to update Game #{game.id}"
    end
  end

  def convert_to_pacific_time(date, start_time)
    eastern_time = Time.strptime("#{date} #{start_time} EDT", "%Y%m%d %I:%M %p %Z")
    eastern_time.in_time_zone('Pacific Time (US & Canada)')
  end
end
