require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesAddBlockTest
      include Spec

      context "Indices: AddBlock: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
          subject.indices.delete({:index => "test2"})
        end

        it "add a write block to an index" do
          subject.indices.create({:index => "test"})
          subject.indices.add_block({:index => "test", :block => "write"})
        end

        it "raises when block is missing" do
          expect_raises(ArgumentError) { subject.indices.add_block({:index => "test"}) }
        end
      end
    end
  end
end
