require "../../spec_helper"

module Elasticsearch
  module Test
    class ActionSearchShardsTest
      include Spec

      context "Action: Search Shards: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test_index"})
        end

        it "should get the shards where search query runs" do
          subject.indices.create({:index => "test_index", :body => {"mappings" => {"type_1" => {} of String => String}}})
          subject.create({:index => "test_index", 
                         :type => "type_1", 
                         :id => "1",
                         :body => {
                            "title" => "Test 1",
                            "tags" => ["y", "z"]
                          }})
          subject.search_shards({:index => "test_index", :type => "type_id"})
        end
      end
    end
  end
end
