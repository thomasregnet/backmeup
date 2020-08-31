# frozen_string_literal: true

require 'thor'

module Backmeup
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'backmeup version'
    def version
      require_relative 'version'
      puts "v#{Backmeup::VERSION}"
    end
    map %w(--version -v) => :version

    desc 'init PATH', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def init(path)
      if options[:help]
        invoke :help, ['init']
      else
        require_relative 'commands/init'
        Backmeup::Commands::Init.new(path, options).execute
      end
    end
  end
end
