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
        root = Backmeup::Root.new(repository)
        newest = Expire.newest(root.backups_path) || return # Expire.newest returns nil if there is no backup

        output.puts(newest.pathname)
      end
    end
  end
end
