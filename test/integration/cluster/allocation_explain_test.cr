require "../../spec_helper"

module Elasticsearch
  module Test
    class ClusterAllocationExplainTest
      include Spec

      context "Cluster: Allocation Explain: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "Explain index allocation" do
          subject.indices.create({:index => "test"})
          subject.cluster.allocation_explain({:body => {"index" => "test", "shard" => "0", "primary" => "true"}})
        end
      end
    end
  end
end
