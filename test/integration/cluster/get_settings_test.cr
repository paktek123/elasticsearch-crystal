require "../../spec_helper"

module Elasticsearch
  module Test
    class ClusterGetSettingsTest
      include Spec

      context "Cluster: GetSettings: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Get cluster settings" do
          subject.cluster.get_settings
        end
      end
    end
  end
end
