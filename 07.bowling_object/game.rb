# frozen_string_literal: true

require './frame'

class Game
  def initialize(game_score)
    all_score = take_in_game(game_score)
    sepalated_score = separate_game_to_frame(all_score)
    @frames = sepalated_score.map { |s| Frame.new(*s) }
  end

  def score
    after_adjustment = @frames.map.with_index do |frame, i|
      if frame.spare?
        sum_spare_score(frame, @frames[i + 1])
      elsif frame.strike?
        sum_strike_score(frame, @frames[i + 1], @frames[i + 2])
      else
        frame.score
      end
    end
    puts after_adjustment.sum
  end

  private

  def take_in_game(game_score)
    game_score.split(',').map { |x| x == 'X' ? 'X' : x.to_i }
  end

  def separate_game_to_frame(game_score)
    frames = []
    frame = []
    game_score.each do |s|
      frame << s
      # 2shot目もframeに入れて欲しい場合nextで2投目処理へnextする。
      # frameが２shot入っていなくストライクではないとき、もしくは10フレーム目はここで処理をループさせる
      next if frame.length != 2 && s != 'X' || frames.length > 9

      frames << frame
      # frames.lengthが9の時のframesに10フレーム目が入った時点で10フレーム目の２投目を入れる為に処理をnextする。
      next if frames.length == 10

      frame = []
    end
    frames
  end

  def sum_spare_score(frame, next_frame)
    frame.score + next_frame&.first_shot&.score.to_i
  end

  def sum_strike_score(frame, next_frame = nil, after_next_frame = nil)
    # ラストフレームの処理
    if @frames[-1] == frame
      frame.score
    # 9フレーム目もしくは、次フレームがストライクではない時の処理
    elsif @frames[-2] == frame || !next_frame.strike?
      frame.score + next_frame.first_shot.score + next_frame.second_shot.score
    # 次フレームがストライクの時の処理（elsifで分岐することで明示的に次フレームがストライクの処理を表す）
    elsif next_frame.strike?
      frame.score + next_frame.first_shot.score + after_next_frame.first_shot.score
    end
  end
end

game = Game.new(ARGV[0])
game.score
