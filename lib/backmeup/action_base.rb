# frozen_string_literal: true

module Backmeup
  # Base-class for actions
  class ActionBase
    def initialize(root:)
      @root = root
    end

    attr_reader :root
  end
end
