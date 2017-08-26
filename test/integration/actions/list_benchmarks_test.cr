require "../../spec_helper"

module Elasticsearch
  module Test
    class ActionsListBenchmarksTest
      include Spec

      context "Actions: List Benchmarks: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "List Benchmarks" do
          subject.list_benchmarks
        end
      end
    end
  end
end
