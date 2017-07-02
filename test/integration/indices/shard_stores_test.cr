require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesShardStoresTest
      include Spec

      context "Indices: Shard Stores: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "recover shard stores information" do
          subject.indices.create({:index => "test"})
          subject.indices.shard_stores({:index => "test"})
        end
      end
    end
  end
end
