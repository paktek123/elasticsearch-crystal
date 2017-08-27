require "../../spec_helper"

module Elasticsearch
  module Test
    class ActionMultipleTermVectorsTest
      include Spec

      context "Action: Multiple Term Vectors: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test_index"})
        end

        it "should get multiple term vectors" do
          subject.indices.create({:index => "test_index", :body => {"mappings" => {"type_1" => {} of String => String}}})
          subject.create({:index => "test_index", 
                         :type => "type_1", 
                         :id => "1",
                         :body => {
                            "title" => "Test 1",
                            "tags" => ["y", "z"]
                          }})
          subject.mtermvectors({:index => "test_index", :type => "type_id", :body => { "ids" => ["1", "2", "3"] }})
        end
      end
    end
  end
end
