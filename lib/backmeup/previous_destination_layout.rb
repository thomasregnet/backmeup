# frozen_string_literal: true

module Backmeup
  # Paths inside the previous destination
  module PreviousDestinationLayout
    def previous_destination_data
      return unless previous_destination

      @previous_destination_data = File.join(previous_destination_path, 'data')
    end

    def previous_destination_path
      return unless previous_destination

      @previous_destination_path = File.join(root.backups, previous_destination)
    end

    def previous_destination_env(other_env = {})
      {
        'PREVIOUS_DESTINATION_DATA' => previous_destination_data,
        'PREVIOUS_DESTINATION_PATH' => previous_destination_path
      }.merge(other_env)
    end
  end
end
