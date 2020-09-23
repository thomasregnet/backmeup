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

        TTY::File.copy_directory('examples', File.join(path, 'examples'))
        FileUtils.chmod(0o755, Dir.glob(File.join(path, 'examples/*')))

        output.puts "created #{path}"
      end
    end
  end
end
