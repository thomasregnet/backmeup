# frozen_string_literal: true

require_relative '../command'

module Backmeup
  module Commands
    # Print the newest backup
    class Newest < Backmeup::Command
      def initialize(repository, options)
        @options    = options
        @repository = repository
      end

      attr_reader :repository

      def execute(input: $stdin, output: $stdout)
        newest = Expire.newest(path) || return # Expire.newest returns nil if there is no backup

        output.puts(newest.path)
      end

      private

      def path
        @path ||= File.join(repository, 'backups')
      end
    end
  end
end
