# frozen_string_literal: true

module Backmeup
  # Example for using `rsync` with the `--link-dest` option
  class ExampleBackupRsyncLinkDest < ExampleBase
    SCRIPT_SOURCE = <<~SCRIPT
      #!/bin/sh
      # -*shell*-

      cmd="rsync"
      cmd="${cmd} --archive"
      cmd="${cmd} --files-from=${FILES_PATH}"
      cmd="${cmd} /"
      cmd="${cmd} ${DESTINATION_DATA}"
      cmd="${cmd} --acls"
      cmd="${cmd} --quiet"
      cmd="${cmd} --recursive"
      cmd="${cmd} --verbose"
      cmd="${cmd} --xattrs"
      cmd="${cmd} --log-file=${DESTINATION_STDOUT}"

      if [ -n "${PREVIOUS_DESTINATION_DATA}" ]; then
        cmd="${cmd} --link-dest=${PREVIOUS_DESTINATION_DATA}"
      fi

      echo $cmd

      $cmd

    SCRIPT

    def script_source
      SCRIPT_SOURCE
    end
  end
end
