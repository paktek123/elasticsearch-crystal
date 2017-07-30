require "../../spec_helper"

module Elasticsearch
  module Test
    class ClusterRerouteTest
      include Spec

      context "Cluster: Reroute: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "Reroute" do
          subject.indices.create({:index => "test"})
          # skipping this for now as tests only have 1 node but theorically this should work just fine
        end
      end
    end
  end
end
