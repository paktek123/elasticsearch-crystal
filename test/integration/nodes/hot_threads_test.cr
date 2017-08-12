require "../../spec_helper"

module Elasticsearch
  module Test
    class NodesHotThreadsTest
      include Spec

      context "Nodes: Hot Threads: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Get hot threads info" do
          subject.nodes.hot_threads({:threads => "10"})
        end
      end
    end
  end
end
