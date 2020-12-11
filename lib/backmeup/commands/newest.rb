# frozen_string_literal: true

require_relative '../command'

module Backmeup
  module Commands
    # Print the newest backup
    class Newest < Backmeup::Command
      def initialize(path, options)
        @options = options
        @path    = path
      end

      attr_reader :path

      def execute(input: $stdin, output: $stdout)
        newest = Expire.newest(path) || return

        output.puts(newest.path) # Expire.newest(path).path
      end
    end
  end
end
