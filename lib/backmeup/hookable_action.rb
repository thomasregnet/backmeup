# frozen_string_literal: true

module Backmeup
  # Execute before and after hooks
  module HookableAction
    def perform
      perform_before_hook
      super
      perform_after_hook
    end

    private

    def after_hook_exist?
      File.exist?(after_hook_path)
    end

    def after_hook_path
      hook_name = "after_#{script_name}"
      File.join(root.bin, hook_name)
    end

    def before_hook_exist?
      File.exist?(before_hook_path)
    end

    def before_hook_path
      hook_name = "before_#{script_name}"
      File.join(root.bin, hook_name)
    end

    def perform_after_hook
      return unless after_hook_exist?

      cmd.run(after_hook_path, env: env)
    end

    def perform_before_hook
      return unless before_hook_exist?

      cmd.run(before_hook_path, env: env)
    end
  end
end
