# frozen_string_literal: true

require "support/shared_examples_for_actions"
require "support/shared_examples_for_hookable_actions"
require "support/shared_examples_for_scriptable_actions"

RSpec.describe Backmeup::CreateDestinationAction do
  subject do
    described_class.new(
      destination: "my_destination",
      previous_destination: nil,
      root: Backmeup::Root.new("fake/path")
    )
  end

  it_behaves_like "an action"

  it_behaves_like "a hookable action" do
    let(:script_name) { "create_destination" }
  end

  it_behaves_like "a scriptable action" do
    let(:script_name) { "create_destination" }
  end

  describe ".perform" do
    let(:root) { Backmeup::Root.new("tmp") }
    let(:destination) { "my_destination" }

    context "without a create_destination script" do
      before do
        FileUtils.mkpath(File.join("tmp", "backups"))

        described_class.perform(
          destination: destination,
          previous_destination: nil,
          root: root
        )
      end

      after { FileUtils.rm_rf(File.join("tmp", "backups")) }

      it "creates the destination" do
        expect(Pathname.new(File.join("tmp", "backups", destination)))
          .to exist
      end
    end

    context "with a create_destination script" do
      let(:cmd) { instance_double("TTY::Command") }

      let(:creator) do
        described_class.new(
          destination: destination,
          previous_destination: nil,
          root: root
        )
      end

      let(:bin_path) { File.join("tmp", "bin") }

      before do
        FileUtils.mkpath(bin_path)
        script_path = File.join(bin_path, "create_destination")
        FileUtils.touch(script_path)
        FileUtils.chmod(0o755, script_path)

        allow(TTY::Command).to receive(:new).and_return(cmd)
        result = spy
        allow(result).to receive(:status).and_return(0)
        allow(cmd).to receive(:run).with(
          "tmp/bin/create_destination",
          {
            env: {
              "DESTINATION_PATH" => "tmp/backups/my_destination",
              "PREVIOUS_DESTINATION_DATA" => nil,
              "PREVIOUS_DESTINATION_PATH" => nil
            }
          }
        ).and_return(result)
      end

      after { FileUtils.rm_rf(bin_path) }

      it "calls cmd.run" do
        creator.perform
        expect(cmd).to have_received(:run)
      end
    end
  end

  describe "#env" do
    let(:env) do
      described_class.new(
        destination: "my_destination",
        previous_destination: "my_previous_destination",
        root: Backmeup::Root.new("root")
      ).send(:env)
    end

    it "sets the DESTINATION_PATH" do
      expect(env["DESTINATION_PATH"])
        .to eq(File.join("root", "backups", "my_destination"))
    end

    it "sets the PREVIOUS_DESTINATION_PATH" do
      expect(env["PREVIOUS_DESTINATION_PATH"]).to eq("my_previous_destination")
    end
  end
end
