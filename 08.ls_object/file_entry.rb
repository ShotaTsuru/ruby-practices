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
end
