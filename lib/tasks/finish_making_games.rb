def finish_making_games
  make_round_1_games
  make_round_2_games
  make_round_3_games
  make_round_4_games
  make_championship
end

def make_next_game_from(round, id, other_id)
  next_game = Game.create(round: round)
  game = Game.find(id)
  other_game = Game.find(other_id)

  game.update(next_game_id: next_game.id)
  other_game.update(next_game_id: next_game.id)
end

def make_round_1_games
  round = 1
  starting_games = [[1, 8], [9, 16], [17, 24], [25, 32]]

  starting_games.each do |low_game, high_game|

    while low_game < high_game
      make_next_game_from(round, low_game, high_game)

      low_game += 1
      high_game -= 1
    end
  end
end

def make_round_2_games
  round = 2
  pairs = [
    [33, 36],
    [34, 35],
    [37, 40],
    [38, 39],
    [41, 44],
    [42, 43],
    [45, 48],
    [46, 47]
  ]
  pairs.each do |low_game, high_game|
    make_next_game_from(round, low_game, high_game)
  end
end

def make_round_3_games
  round = 3
  starting_game = 49
  game = starting_game

  until game > 56
    other_game = game + 1
    make_next_game_from(round, game, other_game)
    game += 2
  end
end

def make_round_4_games
  round = 4
  [[57,58], [59, 60]].each do |low_game, high_game|
    make_next_game_from(round, low_game, high_game)
  end
end

def make_championship
  make_next_game_from(5, 61, 62)
end
