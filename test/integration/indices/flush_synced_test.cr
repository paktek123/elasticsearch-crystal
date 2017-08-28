require "../../spec_helper"

# I seem to be hitting some sort of compiler bug, going to file an issue later, till then no flushing :(

module Elasticsearch
  module Test
    class IndicesFlushSyncedTest
      include Spec
      context "Indices: Flush Synced Test: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "carry out synced flush" do 
          subject.indices.create({:index => "test_index", :body => {"settings" => {"number_of_replicas" => "0"}}})
          subject.cluster.health({:wait_for_status => "green"})
          subject.indices.flush_synced({:index => "test"})
          #json_result = subject.indices.stats({:level => "shards"})  
          #hash_result = json_result.as(JSON::Any).as_h 
          #hash_result["indices"]["test"]["shards"][0][0]["commit"]["user_data"]["sync_id"].should be_true
        end
      end
    end
  end
end
