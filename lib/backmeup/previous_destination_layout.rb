# frozen_string_literal: true

module Backmeup
  # Paths inside the previous destination
  module PreviousDestinationLayout
    def previous_destination_data
      return unless previous_destination

      @previous_destination_data = File.join(previous_destination, 'data')
    end

    def previous_destination_env(other_env = {})
      {
        'PREVIOUS_DESTINATION_DATA' => previous_destination_data,
        'PREVIOUS_DESTINATION_PATH' => previous_destination
      }.merge(other_env)
    end
  end
end
