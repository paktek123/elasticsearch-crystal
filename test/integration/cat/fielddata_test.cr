require "../../spec_helper"

module Elasticsearch
  module Test
    class CatFieldDataTest
      include Spec

      context "Cat: FieldData: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "index"})
        end

        it "help" do
          subject.cat.fielddata({:help => true}).should match /field/
        end

        it "test field data output" do
          (subject.cat.fielddata.as(String).empty?).should be_true
          subject.indices.create({:index => "index", :body => {"mappings" => {
                                                                "type" => {
                                                                  "properties" => {
                                                                    "foo" => {
                                                                      "type" => "text",
                                                                      "fielddata" => true
                                                                      }
                                                                    }
                                                                  } 
                                                                },
                                                               "settings" => {
                                                                 "number_of_shards" => "1"
                                                                }
                                                              }}) 
          subject.index({:index => "index", :type => "type", :body => {"foo" => "bar"}, :refresh => true})
          subject.search({:index => "index", :body => {"query" => {"match_all" => {} of String => String}, "sort" => "foo"} })
          subject.cat.fielddata({:h => "field, size", :v => true}).should match /^field/
          subject.cat.fielddata({:h => "field, size", :fields => "notfoo,foo", :v => true}).should match /^field/
          subject.cat.fielddata({:h => "field, size", :fields => "notfoo", :v => true}).should match /^field/
        end
      end
    end
  end
end
