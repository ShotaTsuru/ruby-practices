#!/usr/bin/env ruby
# frozen_string_literal: true

class Command
  def initialize(files)
    @file_statuses = files.map.with_index do |file, i|
      content = File.read(file)
      {
        n_lines: content.count("\n"), # 行数
        words: content.split(' ').length, # 単語数
        byte_size: content.bytesize, # バイトサイズ
        file_name: files[i]
      }
    end
  end

  def exec_wc(option_l)
    if @file_statuses.empty?
      didnot_get_file(option_l)
    else
      option_l ? exec_default : exec_l_opt
    end
  end

  private

  # オプションなしの出力
  def exec_default
    @file_statuses.each do |file|
      puts "      #{file[:n_lines]}      #{file[:words]}     #{file[:byte_size]} #{file[:file_name]}"
    end
    return unless @file_statuses.length > 1

    total = { total_lines: 0, total_words: 0, total_byte_size: 0 }
    @file_statuses.each do |file|
      total[:total_lines] += file[:n_lines]
      total[:total_words] += file[:words]
      total[:total_byte_size] += file[:byte_size]
    end
    puts "      #{total[:total_lines]}      #{total[:total_words]}     #{total[:total_byte_size]} total"
  end

  def exec_l_opt
    @file_statuses.each do |file|
      puts "      #{file[:n_lines]} #{file[:file_name]}"
    end
    return unless @file_statuses.length > 1

    total = { total_lines: 0, total_words: 0, total_byte_size: 0 }
    @file_statuses.each do |file|
      total[:total_lines] += file[:n_lines]
    end
    puts "      #{total[:total_lines]} total"
  end

  def didnot_get_file(option_l)
    content = $stdin.read
    file = {
      n_lines: content.count("\n"), # 行数
      words: content.split(' ').length, # 単語数
      byte_size: content.bytesize # バイトサイズ
    }
    if option_l
      puts "      #{file[:n_lines]}"
    else
      puts "       #{file[:n_lines]}      #{file[:words]}     #{file[:byte_size]}"
    end
  end
end

if $PROGRAM_NAME == __FILE__
  require 'optparse'
  opt = OptionParser.new

  params = {}

  opt.on('-l') { |v| params[:l] = v }

  opt.parse!(ARGV)
  files = ARGV

  command_receiver = Command.new(files)
  command_receiver.exec_wc(params[:l])
end
