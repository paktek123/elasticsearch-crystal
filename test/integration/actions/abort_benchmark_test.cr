require "../../spec_helper"

module Elasticsearch
  module Test
    class ActionsAbortBenchmarkTest
      include Spec

      context "Actions: Abort Benchmark: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Abort benchmark on query" do
          subject.abort_benchmark({:name => "test_benchmark"})
        end
      end
    end
  end
end
