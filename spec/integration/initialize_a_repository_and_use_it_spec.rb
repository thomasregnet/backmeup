# frozen_string_literal: true

require "tty-file"
require "support/test_data_generator"
require "support/rewind_backups"

# rubocop:disable RSpec/BeforeAfterAll
RSpec.describe "initialize a repository and use it" do
  def backups
    Dir.glob("#{File.join(repository_path, "backups")}/*")
  end

  def repository_path
    @repository_path ||= File.join("tmp", "my_repository")
  end

  def test_data
    @test_data ||= BackmeupTestTool::TestDataGenerator.populate
  end

  before(:all) do
    test_data
    `backmeup init #{repository_path}`

    filelist_path = File.join(repository_path, "config", "filelist")
    TTY::File.create_file(filelist_path, test_data.path)
  end

  after(:all) do
    test_data.destroy
    FileUtils.rm_rf(repository_path)
  end

  it 'creates the "backups" directory' do
    backups_dir = Pathname.new(File.join(repository_path, "backups"))
    expect(backups_dir).to be_directory
  end

  it 'creates the "bin" directory' do
    bin_dir = Pathname.new(File.join(repository_path, "bin"))
    expect(bin_dir).to be_directory
  end

  it 'creates the "config" directory' do
    config_dir = Pathname.new(File.join(repository_path, "config"))
    expect(config_dir).to be_directory
  end

  it 'creates the "examples" directory' do
    examples_dir = Pathname.new(File.join(repository_path, "examples"))
    expect(examples_dir).to be_directory
  end

  describe "`backmeup create`" do
    before(:all) { `backmeup create #{repository_path}` }

    it "created a backmeup" do
      expect(backups.length).to eq(1)
    end

    it "saved the data" do
      backup_dir = File.join(backups.max, "data", "my_data")
      expect(test_data.match_dir?(backup_dir)).to be true
    end
  end

  describe "calling `backmeup create` a second time" do
    before(:all) do
      BackmeupTestTool::RewindBackups.perform

      test_data.mutate
      `backmeup create #{repository_path}`
    end

    it "created a second backup" do
      backup_dir = File.join(backups.max, "data", "my_data")
      # byebug
      expect(test_data.match_dir?(backup_dir)).to be true
    end
  end
end
# rubocop:enable RSpec/BeforeAfterAll
