# frozen_string_literal: true

require_relative "../command"

module Backmeup
  module Commands
    # Print the oldest backup of the repository
    class Oldest < Backmeup::Command
      def initialize(repository, options)
        @options = options
        @repository = repository
      end

      attr_reader :repository

      def execute(input: $stdin, output: $stdout)
        root = Root.new(repository)
        oldest = Expire.oldest(root.backups_path) || return

        output.puts(oldest.pathname)
      end
    end
  end
end
