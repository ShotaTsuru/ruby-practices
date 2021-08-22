# frozen_string_literal: true

class Command
  COLUMN = 3
  def exec(a_option: false, l_option: false, r_option: false)
    files_name = a_option(a_option)
    r_option!(r_option, files_name)
    l_option(l_option, files_name)
  end

  private

  def a_option(a_option)
    all_file = a_option ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    all_file.map do |file|
      FileEntry.new(file)
    end
  end

  def r_option!(r_option, files_name)
    r_option ? files_name.reverse! : files_name
  end

  def l_option(l_option, files_name)
    l_option ? exec_l_opt(files_name) : exec_default(files_name)
  end

  def exec_default(files_name)
    files_num = files_name.length
    row_num = (files_num / COLUMN.to_f).ceil
    rows = Array.new(row_num) { [] }

    until files_name.empty?
      row_num.times do |i|
        rows[0] << files_name.shift if rows[0].length != COLUMN && files_name.length == 1
        rows[i] << files_name.shift unless files_name.empty?
      end
    end

    rows.each do |i|
      puts i.map { |x| x.file_name.ljust(18, ' ') }.join('')
    end
  end

  def exec_l_opt(files_name)
    total_blocks = files_name.map(&:blocks).sum
    puts "total #{total_blocks}"
    files_name.each(&:display_file_detail)
  end
end
