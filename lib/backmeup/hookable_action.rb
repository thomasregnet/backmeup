# frozen_string_literal: true

module Backmeup
  # Execute before and after hooks
  module HookableAction
    def perform
      perform_hook("before")
      super
      perform_hook("after")
    end

    private

    def perform_hook(point)
      hook_name = "#{point}_#{script_name}"

      ScriptIfExist.run(
        env: env,
        root: root,
        script_name: hook_name
      )
    end
  end
end
