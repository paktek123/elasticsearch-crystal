require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesShrinkTest
      include Spec

      context "Indices: Shrink: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "shrink an index into another one" do
          subject.indices.create({:index => "test"})
          subject.indices.shrink({:index => "test", :target => "test2"})
        end
      end
    end
  end
end
