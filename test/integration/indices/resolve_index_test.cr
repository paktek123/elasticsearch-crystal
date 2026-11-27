require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesResolveIndexTest
      include Spec

      context "Indices: ResolveIndex: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
          subject.indices.delete({:index => "test2"})
        end

        it "resolve an index name" do
          subject.indices.create({:index => "test"})
          subject.indices.resolve_index({:name => "te*"})
        end

        it "raises when name is missing" do
          expect_raises(ArgumentError) { subject.indices.resolve_index }
        end
      end
    end
  end
end
