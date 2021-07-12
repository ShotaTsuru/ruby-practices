#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'

class Command
  def exec(a_option: false, l_option: false, r_option: false)
    files_name = a_option ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')

    files_name.reverse! if r_option

    if l_option
      exec_l_opt(files_name)
    else
      exec_default(files_name)
    end
  end

  private

  def exec_default(files_name)
    rows = []
    files_num = files_name.length
    row_num = (files_num / 3.to_f).ceil

    row_num.times do
      rows << []
    end

    until files_name.empty?
      row_num.times do |i|
        # 表示させるファイル名の入った配列の中身が最後の一個であるが、一行目が３列作れてない時の処理
        rows[0] << files_name.shift if rows[0].length != 3 && files_name.length == 1
        rows[i] << files_name.shift unless files_name.empty?
      end
    end

    rows.each do |i|
      puts i.map { |x| x.ljust(18, ' ') }.join('')
    end
  end

  def exec_l_opt(files_name)
    files_status = files_name.map { |file_name| File::Stat.new(file_name) }
    statuses = extract_status(files_status, files_name)
    # 権限の数字をシンボリックに変換
    parts = change_to_symbolic(statuses)
    # 変換したシンボリックを配列のpermissionと交換
    parts.each_with_index { |x, i| statuses[i][:permission] = x }
    total_blocks = statuses.map { |f| f[:blocks] }.sum
    puts "total #{total_blocks}"
    statuses.each do |x|
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

  def change_to_symbolic(statuses)
    change_result = []
    statuses.each_with_index do |status, i|
      symbolic = []
      case status[:type]
      when 'directory'
        permission = 'd'
      when 'file'
        permission = '-'
      when 'link'
        permission = 'l'
      end
      statuses[i][:permission].insert(0, '0') if statuses[i][:permission].length != 6
      results = /\d{3}(\d)(\d)(\d)/.match(statuses[i][:permission]).captures
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
  received_command.exec(a_option: params[:a], l_option: params[:l], r_option: params[:r])
end
