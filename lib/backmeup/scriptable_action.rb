# frozen_string_literal: true

module Backmeup
  # Implement #perform for action and lookup for action-scripts
  module ScriptableAction
    def perform
      script_exists? ? perform_with_script : perform_without_script
    end
  end
end
