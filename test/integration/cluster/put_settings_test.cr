require "../../spec_helper"

module Elasticsearch
  module Test
    class ClusterPutSettingsTest
      include Spec

      context "Cluster: Put Settings: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.cluster.put_settings({:body => {"transient" => {"cluster.routing.allocation.disable_allocation" => "false"}}})
        end

        it "Put settings" do
          subject.cluster.put_settings({:body => {"transient" => {"cluster.routing.allocation.disable_allocation" => "true"}}})
        end
      end
    end
  end
end
