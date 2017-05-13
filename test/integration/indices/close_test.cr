require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesCloseTest
      include Spec

      context "Indices: Close: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "close an index" do
          subject.indices.create({:index => "test"})
          subject.indices.close({:index => "test"})
          subject.cat.indices.as(String).should match /close/
        end
      end
    end
  end
end
