require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesCreateTest
      include Spec

      context "Indices: Create: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test_index"})
        end

        it "should create an index with mappings" do
          subject.indices.create({:index => "test_index", :body => {"mappings" => {"type_1" => {} of String => String}}})
          subject.indices.get_mapping({:index => "test_index"}).to_json.should match /(?=.*mappings)(?=.*type_1)(?=.*test_index)/
        end

        it "should create an index with settings" do 
          subject.indices.create({:index => "test_index", :body => {"settings" => {"number_of_replicas" => "0"}}})
          subject.indices.get_settings({:index => "test_index"}).to_json.should match /(?=.*settings)(?=.*0)(?=.*test_index)(?=.*replicas)/
        end

        it "create index with wait_for_active_shards set to all" do
          subject.indices.create({:index => "test_index", 
                                  :body => {"settings" => {"number_of_replicas" => "0"}},
                                  :wait_for_active_shards => "all"}).to_json.should match /(?=.*acknowledged)(?=.*true)(?=.*shards)/
        end

        it "create index with aliases" do
          subject.indices.create({:index => "test_index", 
                                  :body => {"mappings" => {
                                              "type_1" => {} of String => String
                                              },
                                            "aliases" => {
                                              "test_alias" => {} of String => String,
                                              "test_blias" => {"routing" => "b"},
                                              "test_clias" => {"filter" => {"term" => {"field" => "value"}}}
                                              }
                                            }
                                  })
          subject.indices.get_alias({:index => "test_index"}).to_json.should match /(?=.*test_index)(?=.*test_alias)(?=.*test_blias)(?=.*test_clias)/
        end

        it "create index with no type mappings" do 
          subject.indices.create({:index => "test_index", :body => {"mappings" => {"" => {} of String => String}}}).to_json.should match /illegal_argument_exception/
        end

        it "create index with invalid mappings" do 
          subject.indices.create({:index => "test_index", :body => {"mappings" => {"test_type" => {"properties" => {"" => {"type" => "keyword"}}}}}}).to_json.should match /illegal_argument_exception/
        end
      end
    end
  end
end
