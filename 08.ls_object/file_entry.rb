# frozen_string_literal: true

require 'etc'

class FileEntry
  attr_reader :type, :user, :group, :time, :file_name, :blocks
  attr_accessor :permission, :size, :nlink

  def initialize(file)
    file_status = File::Stat.new(file)
    extract_status(file_status, file)
  end

  def extract_status(file_status, file)
    @type = File.ftype(file) # ファイルタイプ
    @permission = file_status.mode.to_s(8) # 権限
    @nlink = file_status.nlink # ハードリンクの数
    @user = Etc.getpwuid(file_status.uid).name # オーナー名
    @group = Etc.getgrgid(file_status.gid).name # グループ名
    @size = file_status.size # バイトサイズ
    @time = file_status.mtime.to_s.match(/(\d{2})-(\d{2}) (\d{2}:\d{2})/).to_a.values_at(1, 2, 3) # タイムスタンプ
    @file_name = file # ファイル名
    @blocks = file_status.blocks # ブロックサイズ
  end

  def change_to_permission_symbolic
    symbolic = []
    case self.type
    when 'directory'
      permission = 'd'
    when 'file'
      permission = '-'
    when 'link'
      permission = 'l'
    end
    self.permission.insert(0, '0') if self.permission.length != 6
    results = /\d{3}(\d)(\d)(\d)/.match(self.permission).captures

    symbolic << permission
    symbolic << decide_permission(results[0])
    symbolic << decide_permission(results[1])
    symbolic << decide_permission(results[2])
    change_result = symbolic.join
    self.permission = change_result
    self
  end

  def display_file_detail
    self.size = self.size.to_s.rjust(5, ' ')
    self.nlink = self.nlink.to_s.rjust(2, ' ')
    puts "#{self.permission}  #{self.nlink} #{self.user}  #{self.group} #{self.size} #{self.time.join(' ')} #{self.file_name}"
  end

  private

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
