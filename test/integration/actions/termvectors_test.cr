require "../../spec_helper"

module Elasticsearch
  module Test
    class ActionTermVectorsTest
      include Spec

      context "Action: Term Vectors: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test_index"})
        end

        it "should get term vectors" do
          subject.indices.create({:index => "test_index", :body => {"mappings" => {"type_1" => {} of String => String}}})
          subject.create({:index => "test_index", 
                         :type => "type_1", 
                         :id => "1",
                         :body => {
                            "title" => "Test 1",
                            "tags" => ["y", "z"]
                          }})
          subject.termvectors({:index => "test_index", :type => "type_id", :id => "1" })
        end
      end
    end
  end
end
