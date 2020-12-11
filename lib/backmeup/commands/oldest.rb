# frozen_string_literal: true

require_relative '../command'

module Backmeup
  module Commands
    # Print the oldest backup of the repository
    class Oldest < Backmeup::Command
      def initialize(repository, options)
        @options    = options
        @repository = repository
      end

      attr_reader :repository

      def execute(input: $stdin, output: $stdout)
        oldest = Expire.oldest(backups_path) || return

        output.puts(oldest.path)
      end

      private

      def backups_path
        @backups_path ||= File.join(repository, 'backups')
      end
    end
  end
end
