#!/usr/bin/env ruby
# frozen_string_literal: true

class Score
  attr_reader :frame_score

  def initialize
    score = ARGV[0]

    # @resultscore = score.split(',').map{|s| s == 'X'? 10, 0 : s.to_i} 折りたたみ演算で記述したかったのですができず。
    @frame_score = score.split(',').each_with_object([]) do |s, result|
      if s == 'X' # strike
        result << 10 # ここでXのときの返り値が10と0の2つ数字が欲しい為injectで実装が出来ませんでした。
        result << 0
      else
        result << s.to_i
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

  def adjust_last_frame
    @shot_one + @shot_two + @last_shot
  end
end

input_score = Score.new unless ARGV[0].nil?
game = input_score.frame_score.each_slice(2).to_a
frame_scores = game.map { |frame| Frame.new(frame) }.to_a

result_score = 0

if frame_scores[9].shot_one == 10 && frame_scores[10].shot_one == 10 # 10フレーム目の一投目と二投目がストライクのとき
  last_two_frames = frame_scores.pop(2) # ストライクであれば末尾配列２つが必要無くなる。
  frame_scores[9].last_shot = last_two_frames.last.shot_one
  frame_scores[9].shot_two = last_two_frames.first.shot_one
elsif frame_scores[9].shot_one == 10 && frame_scores[10].shot_one != 10 # 10フレーム目の一投目のみストライクの時
  last_frame = frame_scores.pop
  frame_scores[9].last_shot = last_frame.shot_two
  frame_scores[9].shot_two = last_frame.shot_one
# ストライクでなければ3等目を入れている配列を消す
elsif frame_scores[9].shot_one + frame_scores[9].shot_two == 10 # 10フレーム目がスペアのとき
  last_frame = frame_scores.pop
  frame_scores[9].last_shot = last_frame.shot_one
end

frame_scores.each_with_index do |score, i|
  case i
  when 0..8
    result_score += score.shot_one + score.shot_two
    if i == 8 && score.shot_one == 10
      result_score += frame_scores[9].shot_one + frame_scores[9].shot_two
    elsif score.shot_one == 10 && frame_scores[i + 1].shot_one == 10 # 一投目がストラクかつ次のフレームもストライク
      result_score += frame_scores[i + 1].shot_one + frame_scores[i + 2].shot_one
    elsif score.shot_one == 10 # 一投目のみストライク
      result_score += frame_scores[i + 1].shot_one + frame_scores[i + 1].shot_two
    elsif score.shot_one + score.shot_two == 10 # スペア
      result_score += frame_scores[i + 1].shot_one
    end
  when 9
    result_score += frame_scores[9].adjust_last_frame
  end
end

puts result_score
