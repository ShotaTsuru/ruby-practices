# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  # １フレーム1~3投の表示
  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    [@first_shot.score, @second_shot.score, @third_shot.score].sum
  end

  def spare?
    @first_shot.score + @second_shot.score == 10 && @second_shot.score != 0
  end

  def strike?
    @first_shot.score == 10
  end
end
