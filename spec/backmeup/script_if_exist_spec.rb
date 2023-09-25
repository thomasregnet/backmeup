# frozen_string_literal: true

RSpec.describe Backmeup::ScriptIfExist do
  # subject { described_class.new({}) }

  # it { is_expected.to respond_to(:run) }

  describe ".run" do
    let(:bin_path) { File.join("tmp", "bin") }
    let(:script_name) { "test_script" }
    let(:args) do
      {
        env: {},
        root: Backmeup::Root.new("tmp"),
        script_name: script_name
      }
    end

    context "when the script exists and is executable" do
      before do
        FileUtils.mkpath(bin_path)

        script_path = File.join(bin_path, script_name)
        FileUtils.touch(script_path)
        FileUtils.chmod(0o755, script_path)
      end

      after { FileUtils.rm_rf(bin_path) }

      it "returns true" do
        expect(described_class.run(**args)).to be true
      end
    end

    context "when the script exists and is not executable" do
      before do
        FileUtils.mkpath(bin_path)

        script_path = File.join(bin_path, script_name)
        FileUtils.touch(script_path)
        # FileUtils.chmod(0o755, script_path)
      end

      after { FileUtils.rm_rf(bin_path) }

      it "returns raises a RuntimeError" do
        expect { described_class.run(**args) }
          .to raise_error(RuntimeError, "#{script_name} is not executable")
      end
    end

    context "when the script does not exist" do
      it "returns false" do
        expect(described_class.run(**args)).to be false
      end
    end
  end
end
