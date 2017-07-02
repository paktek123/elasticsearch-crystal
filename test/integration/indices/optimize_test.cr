require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesOptimizeTest
      include Spec

      context "Indices: Optimize: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "open an index" do
          subject.indices.create({:index => "test"})
          subject.indices.optimize({:index => "test"})
        end
      end
    end
  end
end
