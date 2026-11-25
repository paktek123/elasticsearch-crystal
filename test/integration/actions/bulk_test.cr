require "../../spec_helper"

module Elasticsearch
  module Test
    class ActionsBulkTest
      include Spec

      context "Actions: Bulk: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Bulk" do
          subject.indices.create({:index => "bulk_test"})

          # Index 3 documents
          response = subject.bulk({:index => "bulk_test", :refresh => "true", :body => [
            {"index" => {"_id" => "1"}},
            {"title" => "foo"},
            {"index" => {"_id" => "2"}},
            {"title" => "bar"},
            {"index" => {"_id" => "3"}},
            {"title" => "baz"},
          ]}).as(JSON::Any)
          response["errors"].as_bool.should eq(false)
          response["items"].as_a.size.should eq(3)

          # Update 1 document and delete 1 (combined format, with the source in `data`)
          response = subject.bulk({:index => "bulk_test", :refresh => "true", :body => [
            {"update" => {"_id" => "1", "data" => {"doc" => {"title" => "updated"}}}},
            {"delete" => {"_id" => "2"}},
          ]}).as(JSON::Any)
          response["errors"].as_bool.should eq(false)

          subject.indices.delete({:index => "bulk_test"})
        end
      end
    end
  end
end
