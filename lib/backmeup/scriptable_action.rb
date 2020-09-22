# frozen_string_literal: true

module Backmeup
  # Implement #perform for action and lookup for action-scripts
  module ScriptableAction
    def perform
      scipt_if_exist || perform_without_script
    end

    protected

    def scipt_if_exist
      ScriptIfExist.run(
        env:         env,
        root:        root,
        script_name: script_name
      )
    end

    def script_name
      match = self.class.to_s.match(/\A.*::(.+)Action\z/) || return
      match[1].underscore
    end
  end
end
