# frozen_string_literal: true

RSpec.describe Backmeup::Root do
  let(:root) { described_class.new("my_backups") }

  describe "#backups" do
    it "returns the backups" do
      expect(root.backups.to_s).to eq(File.join("my_backups", "backups"))
    end
  end

  describe "#backups_path" do
    let(:root) { described_class.new("my_backups") }

    it "returns the backups_path" do
      expect(root.backups_path).to eq(File.join("my_backups", "backups"))
    end

    # It is important to return a string because with eg. a Pathname
    # a File.join() of a calling class will not work
    it "returns a String" do
      expect(root.backups_path).to be_instance_of(String)
    end
  end
end
