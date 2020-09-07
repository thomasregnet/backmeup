# frozen_string_literal: true

module Backmeup
  # The paths of the basedir
  class Root
    def initialize(root_path)
      @base_path = Pathname.new(root_path)
    end

    attr_reader :base_path

    def backups
      @backups ||= Pathname.new(File.join(base_path, 'backups'))
    end

    def bin
      @bin ||= Pathname.new(File.join(base_path, 'bin'))
    end
  end
end
