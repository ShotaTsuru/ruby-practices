#!/usr/bin/env ruby

class Score
  attr_reader :frame_score

  def initialize
    score = ARGV[0]
    @frame_score = []
    # @resultscore = score.split(',').map{|s| s == 'X'? 10, 0 : s.to_i} 折りたたみ演算で記述したかったのですができず。
    score.split(',').each do |s|
      if s == 'X' # strike
        @frame_score << 10
        @frame_score << 0
      else
        @frame_score << s.to_i
      end
    end
  end
end

class Frame
  attr_accessor :shot_one, :shot_two, :last_shot

  def initialize(frame)
    @shot_one = frame[0]
    @shot_two = frame[1]
    @last_shot = 0
  end

  def ajust_last_frame
    @shot_one + @shot_two + @last_shot
  end
end

input_score = Score.new if ARGV[0].nil?
game = []
input_score.frame_score.each_slice(2) do |a|
  game << a
end

frame_scores = []

game.each_with_index do |frame, i|
  frame_scores[i] = Frame.new(frame)
end

result_score = 0

if frame_scores[9].shot_one == 10 && frame_scores[10].shot_one == 10 # 10フレーム目の一投目と二投目がストライクのとき
  frame_scores[9].last_shot = frame_scores[-1].shot_one
  frame_scores[9].shot_two = frame_scores[-2].shot_one
  frame_scores.pop(2) # ストライクであれば末尾配列２つが必要無くなる。
elsif frame_scores[9].shot_one == 10 && frame_scores[10].shot_one != 10 # 10フレーム目の一投目のみストライクの時
  frame_scores[9].last_shot = frame_scores[-1].shot_two
  frame_scores[9].shot_two = frame_scores[-1].shot_one
  frame_scores.pop(1) # ストライクでなければ3等目を入れている配列を消す
elsif frame_scores[9].shot_one + frame_scores[9].shot_two == 10 # 10フレーム目がスペアのとき
  frame_scores[9].last_shot = frame_scores[-1].shot_one
  frame_scores.pop(1)
end

frame_scores.each_with_index do |score, i|
  case i
  when 0..7
    result_score += score.shot_one + score.shot_two
    if score.shot_one == 10 && frame_scores[i + 1].shot_one == 10 # 一投目がストラクかつ次のフレームもストライク
      result_score += frame_scores[i + 1].shot_one + frame_scores[i + 2].shot_one
    elsif score.shot_one == 10 # 一投目のみストライク
      result_score += frame_scores[i + 1].shot_one + frame_scores[i + 1].shot_two
    elsif score.shot_one + score.shot_two == 10 # スペア
      result_score += frame_scores[i + 1].shot_one
    end
  when 8
    result_score += score.shot_one + score.shot_two
    if score.shot_one == 10
      result_score += frame_scores[9].shot_one + frame_scores[9].shot_two
    elsif score.shot_one + score.shot_two == 10
      result_score += frame_scores[9].shot_one
    end
  when 9
    result_score += frame_scores[9].ajust_last_frame
  end
end

puts result_score
