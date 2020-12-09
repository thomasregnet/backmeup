# frozen_string_literal: true

require 'tty-file'

module BackmeupTestTool
  # Generate and mutate test data
  class TestDataGenerator
    DEFAULT_PATH = File.join('tmp', 'my_data')

    def self.populate(**args)
      new(**args).populate
    end

    def initialize(path: DEFAULT_PATH)
      @path = path
    end

    attr_reader :mutation, :path

    def destroy
      FileUtils.rm_rf(path)
    end

    def match_dir?(dir)
      expected = expected_for
      expected.each do |file|
        file_path = File.join(dir, file)
        return false unless File.exist?(file_path)
      end

      true
    end

    def mutate
      @mutation = mutation ? mutation.next : 'A'

      Dir["#{path}/only_*"].each { |file| FileUtils.rm(file) }

      create_file("mutation_#{mutation}", "#{mutation}\n")
      create_file("only_#{mutation}", "#{mutation}\n")
    end

    def populate
      FileUtils.mkpath(path)
      create_file('test', "test\n")
      mutate
      self
    end

    private

    def create_file(name, content)
      file_path = File.join(path, name)
      TTY::File.create_file(file_path, content)
    end

    def expected_for
      expected_files = ['test']

      ('A'..mutation).each { |letter| expected_files << "mutation_#{letter}" }

      expected_files << "only_#{mutation}"
    end
  end
end
