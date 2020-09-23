# frozen_string_literal: true

module Backmeup
  # Base class for examples
  class ExampleBase
    EXAMPLES_DIR = 'examples'

    def self.create(**args)
      new(**args).create
    end

    def initialize(path:)
      @path = path
    end

    attr_reader :path

    def create
      TTY::File.create_file(file_path, script_source)
      FileUtils.chmod(0o755, file_path)
    end

    private

    def file_name
      match = self.class.to_s.match(/Example([A-Za-z]+)\z/) || return
      match[1].underscore
    end

    def file_path
      File.join(path, EXAMPLES_DIR, file_name)
    end
  end
end
