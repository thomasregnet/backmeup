# frozen_string_literal: true

module Backmeup
  # Run a script if it exist and return true, otherwise return false.
  class ScriptIfExist
    def self.run(**args)
      new(**args).run
    end

    def initialize(env:, root:, script_name:)
      @env         = env
      @root        = root
      @script_name = script_name
    end

    attr_reader :env, :root, :script_name

    def run
      File.exist?(script_path) or return false

      raise "#{script_name} is not executable" \
        unless File.executable?(script_path)

      run_cmd

      true
    end

    private

    def script_path
      @script_path ||= File.join(root.bin, script_name)
    end

    def run_cmd
      cmd = TTY::Command.new
      result = cmd.run(script_path, env: env)
      status = result.status
      raise "#{script_name} exited with #{status}" unless status.zero?
    end
  end
end
