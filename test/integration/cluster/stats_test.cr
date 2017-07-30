require "../../spec_helper"

module Elasticsearch
  module Test
    class ClusterStatsTest
      include Spec

      context "Cluster: Stats: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Get cluster stats" do
          subject.cluster.stats
        end
      end
    end
  end
end
