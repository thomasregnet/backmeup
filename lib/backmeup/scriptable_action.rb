# frozen_string_literal: true

module Backmeup
  # Implement #perform for action and lookup for action-scripts
  module ScriptableAction
    def perform
      script_exists? ? perform_with_script : perform_without_script
    end

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

    def script_path
      @script_path ||= File.join(root.bin, script_name)
    end
  end
end
