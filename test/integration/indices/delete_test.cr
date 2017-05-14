require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesDeleteIndexTest
      include Spec

      context "Indices: Delete Index: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "delete an index" do
          subject.indices.create({:index => "test"})
          subject.indices.delete({:index => "test"})
          (subject.cat.indices.as(String).empty?).should be_true
        end
      end
    end
  end
end
