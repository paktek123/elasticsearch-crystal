require "../../spec_helper"

module Elasticsearch
  module Test
    class NodesInfoTest
      include Spec

      context "Nodes: Info: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Get node info" do
          subject.nodes.info({:jvm => "true"})
          subject.nodes.info({:metric => "http,network"})
        end
      end
    end
  end
end
