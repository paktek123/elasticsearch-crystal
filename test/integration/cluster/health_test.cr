require "../../spec_helper"

module Elasticsearch
  module Test
    class ClusterHealthTest
      include Spec

      context "Cluster: Health: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "Get cluster health" do
          subject.indices.create({:index => "test"})
          subject.cluster.health({:wait_for_status => "green"})
        end
      end
    end
  end
end
