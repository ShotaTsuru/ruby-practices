# frozen_string_literal: true

class Game
  attr_reader :first_frame, :second_frame, :third_frame, :fourth_frame, :fifth_frame, :sixth_frame, :seventh_frame,
  :eight_frame, :ninth_frame, :tenth_frame

  def initialize(game_score)
    all_score = take_in_game(game_score)
    sepalated_score = separate_game_to_frame(all_score)
    @fifth_frame = Frame.new()
    @second_frame = Frame.new()
    @third_frame = Frame.new()
    @fourth_frame = Frame.new()
    @fifth_frame = Frame.new()
    @sixth_frame = Frame.new()
    @seventh_frame = Frame.new()
    @eight_frame = Frame.new()
    @ninth_frame = Frame.new()
    @tenth_frame = Frame.new()
  end

  def take_in_game(game_score)
    game_score.split(',').map {|x| x == 'X' ? 'X' : x.to_i }
  end

  def separate_game_to_frame(game_score)
    frames = []
    frame = []
    game_score.each do |s|
      frame << s
      if frame.length == 2 || s == 'X' && frames.length < 9
        frames << frame
        next if frames.length == 10
        frame = []
      end
    end
    frames
  end

end

game =  Game.new(ARGV[0])