# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'expire'
require 'thor'
require 'tty-command'
require 'tty-file'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect('cli' => 'CLI')
loader.setup

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
