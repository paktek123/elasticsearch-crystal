require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesCloneTest
      include Spec

      context "Indices: Clone: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
          subject.indices.delete({:index => "test2"})
        end

        it "clone an index into another one" do
          subject.indices.create({:index => "test"})
          subject.indices.add_block({:index => "test", :block => "write"})
          subject.indices.clone({:index => "test", :target => "test2"})
        end

        it "raises when target is missing" do
          expect_raises(ArgumentError) { subject.indices.clone({:index => "test"}) }
        end
      end
    end
  end
end
