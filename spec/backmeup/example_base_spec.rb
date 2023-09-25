# frozen_string_literal: true

RSpec.describe Backmeup::ExampleBase do
  subject { described_class.new(path: "tmp") }

  it { is_expected.to respond_to(:create) }
  it { is_expected.to respond_to(:path) }
end
