# frozen_string_literal: true

require "active_support"
require "active_support/core_ext"
require "expire"
require "tty-command"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("cli" => "CLI")
loader.setup

module Backmeup
  class Error < StandardError; end
  # Your code goes here...
end
