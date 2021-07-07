#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'

class Command
  # def command_exec(option)
  #   ls_command(**option)
  # end

  def exec(a_option = false, l_option = false, r_option = false)
    files_name = a_option ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')

    files_name.reverse! if r_option

    if l_option
      l_opt(files_name)
    else
      none_opt(files_name)
    end
  end

  private

  def none_opt(files_name)
    array = []
    files_num = files_name.length
    row_num = (files_num / 3.to_f).ceil

    row_num.times do
      array << []
    end

    until files_name.empty?
      row_num.times do |i|
        array[0] << files_name.shift if array[0].length != 3 && files_name.length == 1
        array[i] << files_name.shift unless files_name.empty?
      end
    end

    array.each do |i|
      puts i.map { |x| x.ljust(18, ' ') }.join('')
    end
  end

  def l_opt(files_name)
    files_status = files_name.map { |file_name| File::Stat.new(file_name) }
    array = extract_status(files_status, files_name)
    parts = change_to_symbolic(array) # 権限の数字をシンボリックに変換
    parts.each_with_index { |x, i| array[i][:permission] = x } # 変換したシンボリックを配列のpermissionと交換
    total_blocks = 0
    array.each do |file|
      total_blocks += file[:blocks]
    end
    puts "total #{total_blocks}"
    array.each do |x|
      x[:size] = x[:size].to_s.rjust(5, ' ')
      x[:nlink] = x[:nlink].to_s.rjust(2, ' ')
      puts "#{x[:permission]}  #{x[:nlink]} #{x[:user]}  #{x[:group]} #{x[:size]} #{x[:time].join(' ')} #{x[:file_name]}"
    end
  end

  def extract_status(files_status, files_name)
    files_status.map.with_index do |file_status, i|
      {
        type: File.ftype(files_name[i]), # ファイルタイプ
        permission: file_status.mode.to_s(8), # 権限
        nlink: file_status.nlink, # ハードリンクの数
        user: Etc.getpwuid(files_status[0].uid).name, # オーナー名
        group: Etc.getgrgid(files_status[0].gid).name, # グループ名
        size: file_status.size, # バイトサイズ
        time: file_status.mtime.to_s.match(/(\d{2})-(\d{2}) (\d{2}:\d{2})/).to_a.values_at(1, 2, 3), # タイムスタンプ
        file_name: files_name[i], # ファイル名
        blocks: file_status.blocks # ブロックサイズ
      }
    end
  end

  def change_to_symbolic(array)
    change_result = []
    array.each_with_index do |status, i|
      symbolic = []
      case status[:type]
      when 'directory'
        permission = 'd'
      when 'file'
        permission = '-'
      when 'link'
        permission = 'l'
      end
      array[i][:permission].insert(0, '0') if array[i][:permission].length != 6
      results = /\d{3}(\d)(\d)(\d)/.match(array[i][:permission]).captures
      symbolic << permission
      symbolic << decide_permission(results[0])
      symbolic << decide_permission(results[1])
      symbolic << decide_permission(results[2])
      change_result << symbolic.join
    end
    change_result
  end

  def decide_permission(number)
    {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }[number]
  end
end

if $PROGRAM_NAME == __FILE__
  require 'optparse'
  opt = OptionParser.new

  params = {}

  opt.on('-a') { |v| params[:a] = v }
  opt.on('-l') { |v| params[:l] = v }
  opt.on('-r') { |v| params[:r] = v }
  opt.parse!(ARGV)

  received_command = Command.new
  received_command.exec(params[:a], params[:l], params[:n])
end
