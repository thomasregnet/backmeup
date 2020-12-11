# frozen_string_literal: true

require 'backmeup'
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
    map %w[--version -v] => :version

    desc 'oldest REPOSITORY', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def oldest(repository)
      if options[:help]
        invoke :help, ['oldest']
      else
        require_relative 'commands/oldest'
        Backmeup::Commands::Oldest.new(repository, options).execute
      end
    end

    desc 'newest REPOSITORY', 'Print the newest backup of REPOSITORY'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def newest(repository)
      if options[:help]
        invoke :help, ['newest']
      else
        require_relative 'commands/newest'
        Backmeup::Commands::Newest.new(repository, options).execute
      end
    end

    desc 'create REPOSITORY', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def create(repository)
      if options[:help]
        invoke :help, ['create']
      else
        require_relative 'commands/create'
        Backmeup::Commands::Create.new(repository, options).execute
      end
    end

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
