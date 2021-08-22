#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'
require_relative './file_entry'
require_relative './command'

if $PROGRAM_NAME == __FILE__

  opt = OptionParser.new

  params = {}

  opt.on('-a') { |v| params[:a] = v }
  opt.on('-l') { |v| params[:l] = v }
  opt.on('-r') { |v| params[:r] = v }
  opt.parse!(ARGV)

  received_command = Command.new
  received_command.exec(a_option: params[:a], l_option: params[:l], r_option: params[:r])
end
