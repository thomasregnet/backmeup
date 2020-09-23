# frozen_string_literal: true

require 'tty-file'
require_relative '../command'

module Backmeup
  module Commands
    # Initialize the repository structure
    class Init < Backmeup::Command
      REPOSITORY_DIRECTORIES = %w[backups bin config].freeze

      def initialize(path, options)
        @path = path
        @options = options
      end

      attr_reader :options, :path

      def execute(input: $stdin, output: $stdout)
        REPOSITORY_DIRECTORIES.each do |dir|
          FileUtils.mkpath(File.join(path, dir))
        end

        # example_backup_rsync
        # FileUtils.chmod(0o755, Dir.glob(File.join(path, 'examples/*')))
        ExampleBackupRsync.create(path: path)

        output.puts "created #{path}"
      end

      private

      def example_backup_rsync
        script = <<~SCRIPT
          #!/bin/sh
          # -*shell*-

          exit 0
        SCRIPT

        TTY::File.create_file(
          File.join(path, 'examples', 'backup_rsync'), script
        )
      end
    end
  end
end
