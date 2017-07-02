require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesRolloverTest
      include Spec

      context "Indices: Rollover: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test-000001"})
          subject.indices.delete({:index => "test-000002"})
        end

        it "rollover an alias" do
          subject.indices.put_template({:name => "test", :body => {"order" => 0, 
                                                                   "version" => 1, 
                                                                   "template" => "test",
                                                                   "index_patterns" => "test-*",
                                                                   "settings" => {"number_of_shards" => "1", 
                                                                                  "number_of_replicas" => "0"},
                                                                   "aliases" => {"testali" => {} of String => String}}})
          subject.indices.create({:index => "test-000001"})
          subject.indices.put_alias({:index => "test-000001", :name => "testali"})
          subject.indices.rollover({:alias => "testali", :body => { "conditions" => { "max_docs" => "0" }}})
        end
      end
    end
  end
end
