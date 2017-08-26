require "../../spec_helper"

module Elasticsearch
  module Test
    class ActionDeleteByQueryTest
      include Spec

      context "Action: Delete Document by Query: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test_index"})
        end

        it "should delete a document by query" do
          subject.indices.create({:index => "test_index", :body => {"mappings" => {"type_1" => {} of String => String}}})
          subject.create({:index => "test_index", 
                         :type => "type_1", 
                         :id => "1",
                         :body => {
                            "title" => "Test 1",
                            "tags" => ["y", "z"]
                          }})
          subject.delete_by_query({:index => "test_index", :q => "title: Test 1"})
        end
      end
    end
  end
end
