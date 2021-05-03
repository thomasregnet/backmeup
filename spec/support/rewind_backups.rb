# frozen_string_literal: true

module BackmeupTestTool
  # Set the date of backups to one year before
  class RewindBackups
    DEFAULT_BACKUPS_PATH = File.join('tmp', 'my_repository', 'backups')

    def self.perform(**args)
      new(**args).perform
    end

    def initialize(backups_path: DEFAULT_BACKUPS_PATH)
      @backups_path = backups_path
    end

    attr_reader :backups_path

    def perform
      backup_dirs = Dir["#{backups_path}/*"].reverse
      backup_dirs.each do |backup_dir|
        rewinded_backup_dir = rewinded_backup_dir_for(backup_dir)
        FileUtils.mv(backup_dir, rewinded_backup_dir)
      end
    end

    private

    def basename_of(backup_dir)
      Pathname.new(backup_dir).basename.to_s
    end

    def previous_year_of(backup_dir)
      basename = basename_of(backup_dir)
      match = basename.match(%r{\A(\d{4})-\d\d-\d\d[^/]+\z})
      year = match[1].to_i
      previous_year = year - 1
      previous_year.to_s
    end

    def rewinded_backup_dir_for(backup_dir)
      basename = basename_of(backup_dir)
      previous_year = previous_year_of(backup_dir)
      previous_basename = basename.sub(/\A\d{4}/, previous_year)
      File.join(backups_path, previous_basename)
    end
  end
end
