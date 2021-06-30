#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
p ARGV

class Command
  attr_reader :a, :l, :r
  def initialize(command_line)
    unless command_line.empty?
      command_array = command_split(command_line)
      @a = command_array[0]
      @l = command_array[1]
      @r = command_array[2]
    end
  end

  def command_exec
    ls_default
    a_opt if @a
    l_opt if @l
    r_opt if @r
  end

  def ls_default
    puts "default"
  end

  def a_opt
    puts "a"
  end

  def l_opt
    puts "l"
  end

  def r_opt
    puts "r"
  end

  private

  def command_split(command_line)
    command_array = command_line[0].split(//)
    command_array.delete("-")
    command_array.sort
  end
end


received_command = Command.new(ARGV)
received_command.command_exec

