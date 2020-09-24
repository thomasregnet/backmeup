# frozen_string_literal: true

module Backmeup
  # Example for using `rsync`
  class ExampleBackupRsync < ExampleBase
    SCRIPT_SOURCE = <<~SCRIPT
      #!/bin/sh
      # -*shell*-

      exit 0
    SCRIPT

    def script_source
      SCRIPT_SOURCE
    end
  end
end
