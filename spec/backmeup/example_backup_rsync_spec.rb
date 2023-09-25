# frozen_string_literal: true

require "support/shared_examples_for_example_classes"

RSpec.describe Backmeup::ExampleBackupRsync do
  subject { described_class.new(path: "tmp") }

  it_behaves_like "an example class" do
    let(:script_name) { "backup_rsync" }
  end
end
