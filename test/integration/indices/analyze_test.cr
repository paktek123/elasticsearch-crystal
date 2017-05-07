require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesAnalyzeTest
      include Spec

      context "Indices: Analyze: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          #subject.indices.delete({:index => "test"})
        end

        it "basic test" do
          result = subject.indices.analyze({:body => {"text" => "Foo Bar", "analyzer" => "standard"}})
          result.as(JSON::Any).as_h.has_key?("tokens").should be_true 
        end

        it "index and field" do
          # I seem to be a getting a 503 and no shard available exception
          #subject.indices.create({:index => "test", :body => {"mappings" => {
          #                                                      "test" => {
          #                                                        "properties" => {
          #                                                          "text" => {
          #                                                            "type" => "text",
          #                                                            "analyzer" => "standard"
          #                                                            }
          #                                                          }
          #                                                        } 
          #                                                      }}})
          #result = subject.indices.analyze({:index => "test", :body => {"field" => "text", "text" => "Foo Bar!"}})
          #result.should match /foo/ 
          #result.as(JSON::Any).as_h.has_key?("tokens").should be_true 
        end
      end
    end
  end
end
