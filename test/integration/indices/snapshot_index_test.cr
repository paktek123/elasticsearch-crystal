require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesSnapshotIndexTest
      include Spec

      context "Indices: SnapshotIndex: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "snapshot an index" do
          subject.indices.create({:index => "test"})
          subject.indices.snapshot_index({:index => "test"})
        end
      end
    end
  end
end
