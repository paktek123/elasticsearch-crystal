require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesStatsTest
      include Spec

      context "Indices: Stats: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "stats" do
          subject.indices.create({:index => "test"})
          subject.indices.stats({:index => "test", :level => "shards"})
        end
      end
    end
  end
end
