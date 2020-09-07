# frozen_string_literal: true

module Backmeup
  # Base-class for actions
  class ActionBase
    def initialize(root:)
      @root = root
    end

    attr_reader :root

    protected

    def cmd
      TTY::Command.new
    end

    def script_exists?
      root.bin.glob(script_name)[0] ? true : false
    end

    def script_name
      match = self.class.to_s.match(/\A.*::(.+)Action\z/) || return
      match[1].underscore
    end

    def script_pathname
      @script_pathname ||= Pathname.new(File.join(root.bin, script_name))
    end
  end
end
