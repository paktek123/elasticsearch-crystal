require "../../spec_helper"

module Elasticsearch
  module Test
    class ClusterStateTest
      include Spec

      context "Cluster: State: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Get cluster state" do
          subject.cluster.state
        end
      end
    end
  end
end
