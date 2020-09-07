# frozen_string_literal: true

require_relative '../command'

module Backmeup
  module Commands
    class Create < Backmeup::Command
      def initialize(repository, options)
        @repository = repository
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        # Command logic goes here ...
        output.puts "OK"
      end
    end
  end
end
