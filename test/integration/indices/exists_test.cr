require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesExistTest
      include Spec

      context "Indices: Exists: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "check if index exists" do
          subject.indices.exists({:index => "test"}).should be_false
          subject.indices.create({:index => "test"})
          subject.indices.exists({:index => "test"}).should be_true
        end
      end
    end
  end
end
