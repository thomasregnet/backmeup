# frozen_string_literal: true

require 'tty-file'

module BackmeupTestTool
  # Generate and mutate test data
  class DataDirGenerator
    DEFAULT_PATH = File.join('tmp', 'my_data')

    def self.create(**args)
      new(**args).create
    end

    def self.populate(**args)
      new(**args).create.populate
    end

    def initialize(path: DEFAULT_PATH)
      @path = path
    end

    attr_reader :path

    def create
      FileUtils.mkpath(path)
      self
    end

    def destroy
      FileUtils.rm_rf(path)
    end

    def expected_for(iteration = nil)
      expected_files = ['test']

      return expected_files unless iteration

      ('A'..iteration).each { |letter| expected_files << "iteration_#{letter}" }

      expected_files << "only_#{iteration}"
    end

    def match_dir?(dir, iteration = nil)
      expected = expected_for(iteration)
      expected.each do |file|
        file_path = File.join(dir, file)
        return false unless File.exist?(file_path)
      end

      true
    end

    def mutate(iteration)
      Dir["#{path}/only_*"].each { |file| FileUtils.rm(file) }

      create_file("iteration_#{iteration}", "#{iteration}\n")
      create_file("only_#{iteration}", "#{iteration}\n")
    end

    def populate
      create_file('test', "test\n")
      self
    end

    def create_file(name, content)
      file_path = File.join(path, name)
      TTY::File.create_file(file_path, content)
    end
  end
end
