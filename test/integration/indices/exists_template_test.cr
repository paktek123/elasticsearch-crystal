require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesExistsTemplateTest
      include Spec

      context "Indices: Exists Template: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

       it "template exists" do
          subject.indices.put_template({:name => "test", :body => {"order" => 0, 
                                                                   "version" => 1, 
                                                                   "template" => "test",
                                                                   "index_patterns" => "test-*",
                                                                   "settings" => {"number_of_shards" => "1", 
                                                                                  "number_of_replicas" => "0"}}})
          subject.indices.exists_template({:name => "test"}).should be_true
          subject.indices.delete_template({:name => "test"})
        end
      end
    end
  end
end
