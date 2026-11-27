require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesSplitTest
      include Spec

      context "Indices: Split: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
          subject.indices.delete({:index => "test2"})
        end

        it "split an index into another one" do
          subject.indices.create({:index => "test", :body => {"settings" => {"index.number_of_shards" => 1, "index.number_of_routing_shards" => 2}}})
          subject.indices.add_block({:index => "test", :block => "write"})
          subject.indices.split({:index => "test", :target => "test2", :body => {"settings" => {"index.number_of_shards" => 2}}})
        end

        it "raises when target is missing" do
          expect_raises(ArgumentError) { subject.indices.split({:index => "test"}) }
        end
      end
    end
  end
end
