# frozen_string_literal: true

RSpec.describe Backmeup::ActionBase do
  subject { described_class.new(root: :fake_root) }

  it { should respond_to(:root) }
end
