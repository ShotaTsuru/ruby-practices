# frozen_string_literal: true

require 'etc'

class FileEntry
  attr_reader :type, :user, :group, :time, :file_name, :blocks, :permission, :size, :nlink

  def initialize(file)
    file_status = File::Stat.new(file)
    extract_status(file_status, file)
  end

  def display_file_detail
    only_display_size = size.to_s.rjust(5, ' ')
    only_display_nlink = nlink.to_s.rjust(2, ' ')
    puts "#{permission}  #{only_display_nlink} #{user}  #{group} #{only_display_size} #{time.join(' ')} #{file_name}"
  end

  private

  def extract_status(file_status, file)
    @type = File.ftype(file) # ファイルタイプ
    @permission = change_to_permission_symbolic(file_status.mode.to_s(8)) # 権限
    @nlink = file_status.nlink # ハードリンクの数
    @user = Etc.getpwuid(file_status.uid).name # オーナー名
    @group = Etc.getgrgid(file_status.gid).name # グループ名
    @size = file_status.size # バイトサイズ
    @time = file_status.mtime.to_s.match(/(\d{2})-(\d{2}) (\d{2}:\d{2})/).to_a.values_at(1, 2, 3) # タイムスタンプ
    @file_name = file # ファイル名
    @blocks = file_status.blocks # ブロックサイズ
  end

  def change_to_permission_symbolic(mode)
    symbolic = []
    case type
    when 'directory'
      permission = 'd'
    when 'file'
      permission = '-'
    when 'link'
      permission = 'l'
    end
    mode.insert(0, '0') if mode.length != 6
    results = /\d{3}(\d)(\d)(\d)/.match(mode).captures

    symbolic << permission
    symbolic << decide_permission(results[0])
    symbolic << decide_permission(results[1])
    symbolic << decide_permission(results[2])
    symbolic.join
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
