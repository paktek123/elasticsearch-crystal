require "../../spec_helper"

module Elasticsearch
  module Test
    class ActionCountPercolateTest
      include Spec

      context "Action: Count Percolate: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "Count Percolate" do
          subject.indices.create({:index => "test"})
          subject.count_percolate({:index => "test", :type => "my-type", :id => "123"})
        end
      end
    end
  end
end
