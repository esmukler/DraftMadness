def set_first_round_times
  times = [ nil,
    # South
    Time.local(2016, 'mar', 17, 13),
    Time.local(2016, 'mar', 18, 9, 40),
    Time.local(2016, 'mar', 17, 5, 50),
    Time.local(2016, 'mar', 18, 11),
    Time.local(2016, 'mar', 18, 13, 30),
    Time.local(2016, 'mar', 17, 18, 20),
    Time.local(2016, 'mar', 18, 12, 10),
    Time.local(2016, 'mar', 18, 10, 30),
    # West
    Time.local(2016, 'mar', 18, 16, 27),
    Time.local(2016, 'mar', 18, 13),
    Time.local(2016, 'mar', 18, 16, 20),
    Time.local(2016, 'mar', 17, 9, 15),
    Time.local(2016, 'mar', 17, 11, 45),
    Time.local(2016, 'mar', 18, 18, 50),
    Time.local(2016, 'mar', 18, 10, 30),
    Time.local(2016, 'mar', 18, 18, 57),
    # East
    Time.local(2016, 'mar', 17, 16, 20),
    Time.local(2016, 'mar', 18, 18, 20),
    Time.local(2016, 'mar', 18, 16, 10),
    Time.local(2016, 'mar', 17, 18, 40),
    Time.local(2016, 'mar', 17, 16, 10),
    Time.local(2016, 'mar', 18, 18, 40),
    Time.local(2016, 'mar', 18, 15, 50),
    Time.local(2016, 'mar', 17, 18, 50),
    # Midwest
    Time.local(2016, 'mar', 17, 12, 10),
    Time.local(2016, 'mar', 18, 11, 45),
    Time.local(2016, 'mar', 17, 16, 27),
    Time.local(2016, 'mar', 17, 11),
    Time.local(2016, 'mar', 17, 13, 30),
    Time.local(2016, 'mar', 17, 18, 57),
    Time.local(2016, 'mar', 18, 9, 15),
    Time.local(2016, 'mar', 18, 11, 45)
  ]
  33.times do |idx|
    time = times[idx]
    next unless time
    game = Game.find(idx)
    game.update(start_time: time)
  end
end
