require "../../spec_helper"

module Elasticsearch
  module Test
    class ActionsBulkTest
      include Spec

      context "Actions: Bulk: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Bulk" do
          subject.indices.create({:index => "test"})
          subject.bulk({:body => [
                         { "index" => { "_index" => "test", "_type" => "mytype", "_id" => "1"}},
                         { "title" => "foo" },
                         { "delete" => { "_index" => "test", "_type" => "mytype", "_id" => "2"}},    
            ]}
          )
        end
      end
    end
  end
end
