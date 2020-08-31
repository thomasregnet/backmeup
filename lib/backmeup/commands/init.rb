# frozen_string_literal: true

require_relative '../command'

module Backmeup
  module Commands
    # Initialize the directory structure
    class Init < Backmeup::Command
      def initialize(path, options)
        @path = path
        @options = options
      end

      attr_reader :options, :path

      def execute(input: $stdin, output: $stdout)
        # Command logic goes here ...
        FileUtils.mkpath(path)
        FileUtils.mkpath(File.join(path, 'backups'))
        FileUtils.mkpath(File.join(path, 'bin'))
        FileUtils.mkpath(File.join(path, 'config'))

        output.puts "created #{path}"
      end
    end
  end
end
