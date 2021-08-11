# frozen_string_literal: true

require './frame'

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
    game_score.split(',').map { |x| x == 'X' ? 'X' : x.to_i }
  end

  def separate_game_to_frame(game_score)
    frames = []
    frame = []
    game_score.each do |s|
      frame << s
      next unless frame.length == 2 || s == 'X' && frames.length < 9

      frames << frame
      next if frames.length == 10

      frame = []
    end
    frames
  end

  def calc_result_score
    @full_frame = [@first_frame, @second_frame, @third_frame, @fourth_frame, @fifth_frame, @sixth_frame, @seventh_frame, @eight_frame, @ninth_frame,
                   @tenth_frame]
    after_adjustment = @full_frame.map.with_index do |frame, i|
      if frame.spare?
        sum_spare_score(frame, @full_frame[i + 1])
      elsif frame.strike?
        sum_strike_score(frame, @full_frame[i + 1], @full_frame[i + 2])
      else
        frame.score
      end
    end
    puts after_adjustment.sum
  end

  def sum_spare_score(frame, next_frame)
    frame.score + next_frame&.first_shot&.score.to_i
  end

  def sum_strike_score(frame, next_frame = nil, after_next_frame = nil)
    # last frameと9frame目、次フレームがストライクではない時の処理。
    # next_frame&の処理でnilが返る＝last frame !nilでtrue処理へ。
    if !next_frame&.strike? || @full_frame[-2] == frame
      # last frame用にぼっち演算子とぼっち演算子適応後の値nilをto_iで0に変換
      frame.score + next_frame&.first_shot&.score.to_i + next_frame&.second_shot&.score.to_i
    else
      frame.score + next_frame.first_shot.score + after_next_frame.first_shot.score
    end
  end
end

game = Game.new(ARGV[0])
game.calc_result_score
