require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesGetFieldMappingTest
      include Spec

      context "Indices: Get Field Mapping: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "get a field mapping" do
          subject.indices.create({:index => "test", :body => {"mappings" => {
                                                                "document" => {
                                                                  "properties" => {
                                                                    "title" => {
                                                                      "type" => "text",
                                                                      "fields" => {
                                                                        "title" =>  { "type" => "text"},
                                                                      }
                                                                    }
                                                                  }
                                                                }
                                                              }}})
          subject.indices.get_field_mapping({:index => "test", :field => ["title"]})
        end
      end
    end
  end
end
