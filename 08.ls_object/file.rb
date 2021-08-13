# frozen_string_literal: true

require 'etc'

class File
  attr_reader :permission, :nlink, :user, :group, :size, :time, :file_name
  def initialize
  end

end

file = File.new