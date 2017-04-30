require "../../spec_helper"

module Elasticsearch
  module Test
    class CatIndicesTest
      include Spec

      context "Cat: Indices: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "index1"})
        end

        it "help" do
          (subject.cat.indices.as(String).empty?).should be_true
        end

        it "test indices output" do
          (subject.cat.indices.as(String).empty?).should be_true
          subject.indices.create({:index => "index1", :body => {"settings" => {"number_of_shards" => "1", 
                                                                               "number_of_replicas" => "0"}}})
          subject.cat.indices.should match /index1/
        end

        it "test indices output with wildcards" do
          subject.indices.create({:index => "index1"})
          subject.cat.indices({:index => "in*"}).should match /index1/
        end
      end
    end
  end
end
