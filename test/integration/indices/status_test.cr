require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesStatusTest
      include Spec

      context "Indices: Status: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "status of an index" do
          subject.indices.create({:index => "test"})
          subject.indices.status({:index => "test"})
        end
      end
    end
  end
end
