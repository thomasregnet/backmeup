# frozen_string_literal: true

RSpec.describe 'initialize a repository and use it' do
  def repository_path
    @repository_path ||= File.join('tmp', 'my_repository')
  end

  # rubocop:disable RSpec/BeforeAfterAll
  before(:all) do
    `backmeup init #{repository_path}`
  end

  after(:all) { FileUtils.rm_rf(repository_path) }
  # rubocop:enable RSpec/BeforeAfterAll

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
end
