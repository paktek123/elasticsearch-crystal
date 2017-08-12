require "../../spec_helper"

module Elasticsearch
  module Test
    class NodesStatsTest
      include Spec

      context "Nodes: Stats: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Get stats info" do
          subject.nodes.stats({:metric => "jvm"})
        end
      end
    end
  end
end
