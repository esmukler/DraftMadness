class Games < Thor
  require './config/environment.rb'

  no_commands do
    def cbs_schedule_url(date)
      "https://www.cbssports.com/college-basketball/schedule/NCAA/#{date}/"
    end

    def convert_time(text)
      time = Time.parse(text)
      # set it back 3 hours to make it PDT
      time - (60 * 60 * 3)
    end

    def parse_site(resp_body)
      doc = Nokogiri::HTML(resp_body)
      game_divs = doc.css('tbody tr')

      year = Time.now.year
      date_text = date_text = doc.css('.ToggleContainer-button.is-active').text.strip()

      game_divs.each do |game_div|
        slugs = game_div.css('.TeamLogoNameLockup a').map do |link|
          get_slug_from_link(link.attributes['href'].value)
        end.uniq
        time_text = game_div.css('.CellGame a')[0].text.strip()


        slug_schools = School.where(year: year, slug: slugs)
        next if slug_schools.count < 2
        game = Game.from_year(year).find_by_schools(*slug_schools)
        time = convert_time("#{date_text} #{time_text}")
        puts "#{game.schools.map(&:name).join(' and ')} start at #{time}"
        game.update(start_time: time)
      end
    end

    def get_slug_from_link(link)
      link.match(/college-basketball\/teams\/([\w]+)\//)[1]
    end
  end

  desc 'get_times', 'Get Game times'
  def set_times(date)
    resp = RestClient.get(cbs_schedule_url(date))

    fail unless resp.code.between?(200, 299)

    parse_site(resp.body)
  end
end
