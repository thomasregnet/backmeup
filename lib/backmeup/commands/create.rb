# frozen_string_literal: true

require_relative '../command'

module Backmeup
  module Commands
    # Create a backup
    class Create < Backmeup::Command
      def initialize(repository, options)
        @repository = repository
        @options = options
      end

      attr_reader :options, :repository

      def execute(input: $stdin, output: $stdout)
        # previous_destination = Expire.newest
        # destination = DateTime.now.to_s
        # CreateDestinationAction.perform(
        #   destination: destination,
        #   previous_destination: previous_destination,
        #   root: root
        # )

        # CreateBackupAction.perform(
        #   destination: destination,
        #   previous_destination: previous_destination,
        #   root: root
        # )
        output.puts('OK')
      end

      def root
        @root ||= Backmeup::Root.new(repository)
      end
    end
  end
end
