# frozen_string_literal: true

require 'tty-file'

RSpec.describe 'initialize a repository and use it' do
  def backups
    Dir.glob("#{File.join(repository_path, 'backups')}/*")
  end

  def repository_path
    @repository_path ||= File.join('tmp', 'my_repository')
  end

  def data_path
    @data_path ||= File.join('tmp', 'my_data')
  end

  # rubocop:disable RSpec/BeforeAfterAll
  before(:all) do
    `backmeup init #{repository_path}`

    FileUtils.mkpath(data_path)
    TTY::File.create_file(File.join(data_path, 'test'), "test\n")

    filelist_path = File.join(repository_path, 'config', 'filelist')
    TTY::File.create_file(filelist_path, data_path)
  end

  after(:all) do
    FileUtils.rm_rf(data_path)
    FileUtils.rm_rf(repository_path)
  end

  it 'creates the "backups" directory' do
    backups_dir = Pathname.new(File.join(repository_path, 'backups'))
    expect(backups_dir).to be_directory
  end

  it 'creates the "bin" directory' do
    bin_dir = Pathname.new(File.join(repository_path, 'bin'))
    expect(bin_dir).to be_directory
  end

  it 'creates the "config" directory' do
    config_dir = Pathname.new(File.join(repository_path, 'config'))
    expect(config_dir).to be_directory
  end

  it 'creates the "examples" directory' do
    examples_dir = Pathname.new(File.join(repository_path, 'examples'))
    expect(examples_dir).to be_directory
  end

  describe '`backmeup create`' do
    before(:all) { `backmeup create #{repository_path}` }

    it 'created a backmeup' do
      expect(backups.length).to eq(1)
    end

    it 'saved the data' do
      test_path = File.join(backups.first, 'data', 'my_data', 'test')
      expect(File.read(test_path)).to eq("test\n")
    end
  end
  # rubocop:enable RSpec/BeforeAfterAll
end
