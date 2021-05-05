# frozen_string_literal: true

require_relative '../command'

module Backmeup
  module Commands
    # Create a backup
    class Create < Backmeup::Command
      def initialize(repository, options)
        @repository = repository
        @options    = options

        # previous_destination must be detected before the destination is created,
        # otherwise the previous_destination equals destination.
        # That said, previous_destination is detected here in the constructor.
        @previous_destination = Expire.newest(root.backups_path)&.pathname.to_s
      end

      def execute(input: $stdin, output: $stdout)
        create_destination
        create_backup

        output.puts('OK')
      end

      private

      attr_reader :options, :previous_destination, :repository

      def create_backup
        CreateBackupAction.perform(
          destination:          destination,
          previous_destination: previous_destination,
          root:                 root
        )
      end

      def create_destination
        CreateDestinationAction.perform(
          destination:          destination,
          previous_destination: previous_destination,
          root:                 root
        )
      end

      def destination
        @destination ||= Time.now.utc.to_s.sub(' ', 'T').sub(' ', '_')
      end

      def root
        @root ||= Backmeup::Root.new(repository)
      end
    end
  end
end
