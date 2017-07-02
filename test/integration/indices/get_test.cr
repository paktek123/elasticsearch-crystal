require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesGetTest
      include Spec

      context "Indices: Get: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test_index"})
        end

        it "should get an index with settings" do 
          subject.indices.create({:index => "test_index", :body => {"settings" => {"number_of_replicas" => "0"}}})
          subject.indices.get({:index => "test_index"})
        end
      end
    end
  end
end
