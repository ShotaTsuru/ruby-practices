# frozen_string_literal: true

# 点数を入れて表示させる
class Shot
  attr_accessor :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if mark == 'X'

    mark.to_i
  end
end
