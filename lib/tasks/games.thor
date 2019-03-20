class Games < Thor
  require './config/environment.rb'

  no_commands do
    def cbs_schedule_url(date)
      "https://www.cbssports.com/college-basketball/schedule/NCAA/#{date}/"
    end

    def parse_site(resp_body)
      doc = Nokogiri::HTML(resp_body)
      game_divs = doc.css('tbody tr')

      game_divs.each do |game_div|
        slugs = game_div.css('.TeamLogoNameLockup a').map do |link|
          get_slug_from_link(link.attributes['href'].value)
        end.uniq
        time_text = game_div.css('.CellGame a')[0].text.strip()

        puts "#{slugs[0]} and #{slugs[1]} play at #{time_text}"
      end
    end

    def get_slug_from_link(link)
      link.match(/college-basketball\/teams\/([\w]+)\//)[1]
    end
  end

  desc 'get_times', 'Get Game times'
  def get_times(date)
    resp = RestClient.get(cbs_schedule_url(date))

    fail unless resp.code.between?(200, 299)

    parse_site(resp.body)
  end

# def set_first_round_times
#   times = [ nil,
#     # South
#     Time.local(2016, 'mar', 17, 13),
#     Time.local(2016, 'mar', 18, 9, 40),
#     Time.local(2016, 'mar', 17, 15, 50),
#     Time.local(2016, 'mar', 18, 11),
#     Time.local(2016, 'mar', 18, 13, 30),
#     Time.local(2016, 'mar', 17, 18, 20),
#     Time.local(2016, 'mar', 18, 12, 10),
#     Time.local(2016, 'mar', 18, 10, 30),
#     # West
#     Time.local(2016, 'mar', 18, 16, 27),
#     Time.local(2016, 'mar', 18, 13),
#     Time.local(2016, 'mar', 18, 16, 20),
#     Time.local(2016, 'mar', 17, 9, 15),
#     Time.local(2016, 'mar', 17, 11, 45),
#     Time.local(2016, 'mar', 18, 18, 50),
#     Time.local(2016, 'mar', 18, 10, 30),
#     Time.local(2016, 'mar', 18, 18, 57),
#     # East
#     Time.local(2016, 'mar', 17, 16, 20),
#     Time.local(2016, 'mar', 18, 18, 20),
#     Time.local(2016, 'mar', 18, 16, 10),
#     Time.local(2016, 'mar', 17, 18, 40),
#     Time.local(2016, 'mar', 17, 16, 10),
#     Time.local(2016, 'mar', 18, 18, 40),
#     Time.local(2016, 'mar', 18, 15, 50),
#     Time.local(2016, 'mar', 17, 18, 50),
#     # Midwest
#     Time.local(2016, 'mar', 17, 12, 10),
#     Time.local(2016, 'mar', 18, 11, 45),
#     Time.local(2016, 'mar', 17, 16, 27),
#     Time.local(2016, 'mar', 17, 11),
#     Time.local(2016, 'mar', 17, 13, 30),
#     Time.local(2016, 'mar', 17, 18, 57),
#     Time.local(2016, 'mar', 18, 9, 15),
#     Time.local(2016, 'mar', 18, 11, 45)
#   ]
#   33.times do |idx|
#     time = times[idx]
#     next unless time
#     game = Game.find(idx)
#     game.update(start_time: time)
#   end
# end
end
