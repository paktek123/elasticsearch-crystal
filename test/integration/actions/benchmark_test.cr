require "../../spec_helper"

module Elasticsearch
  module Test
    class ActionsBenchmarkTest
      include Spec

      context "Actions: Benchmark: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Get benchmark on query" do
          subject.benchmark({:body => {"name" => "test_benchmark", 
                                       "competitors" => [
                                          {"name" => "query_1", 
                                          "requests" => [
                                            {"query" => {"match" => {"_all" => "a*"}}}
                                          ]}]
                                      }
                            })
        end
      end
    end
  end
end
