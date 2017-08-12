require "../../spec_helper"

module Elasticsearch
  module Test
    class NodesShutdownTest
      include Spec

      context "Nodes: Shutdown: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Shutdown a node" do
          # not going to do this test, need to first spin up a new node and then shut it down
          #subject.nodes.shutdown({:node_id => "TestNode"})
        end
      end
    end
  end
end
