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
        create_destination
        create_backup

        output.puts('OK')
      end

      private

      def create_backup
        CreateBackupAction.perform(
          destination: destination,
          previous_destination: previous_destination,
          root: root
        )
      end

      def create_destination
        CreateDestinationAction.perform(
          destination: destination,
          previous_destination: previous_destination,
          root: root
        )
      end

      def destination
        @destination ||= DateTime.now.to_s
      end

      def previous_destination
        @previous_destination ||= Expire.newest(repository)
      end

      def root
        @root ||= Backmeup::Root.new(repository)
      end
    end
  end
end
