# frozen_string_literal: true

require './frame.rb'

class Game
  attr_reader :first_frame, :second_frame, :third_frame, :fourth_frame, :fifth_frame, :sixth_frame, :seventh_frame,
  :eight_frame, :ninth_frame, :tenth_frame

  def initialize(game_score)
    all_score = take_in_game(game_score)
    sepalated_score = separate_game_to_frame(all_score)
    @first_frame = Frame.new(*sepalated_score[0])
    @second_frame = Frame.new(*sepalated_score[1])
    @third_frame = Frame.new(*sepalated_score[2])
    @fourth_frame = Frame.new(*sepalated_score[3])
    @fifth_frame = Frame.new(*sepalated_score[4])
    @sixth_frame = Frame.new(*sepalated_score[5])
    @seventh_frame = Frame.new(*sepalated_score[6])
    @eight_frame = Frame.new(*sepalated_score[7])
    @ninth_frame = Frame.new(*sepalated_score[8])
    @tenth_frame = Frame.new(*sepalated_score[9])
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

  def result_score
    if @first_frame.spare?
    end

  end

end

game =  Game.new(ARGV[0])

puts game