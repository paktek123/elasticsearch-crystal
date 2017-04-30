require "../../spec_helper"

module Elasticsearch
  module Test
    class CatShardsTest
      include Spec

      context "Cat: Shards: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "index1"})
        end

        it "help" do
          (subject.cat.shards({:help => true}).as(String).empty?).should be_false
        end

        it "test shards output" do
          (subject.cat.shards.as(String).empty?).should be_true
          subject.indices.create({:index => "index1"})
          subject.cat.shards.should match /index1/
        end

        it "check shards are not empty with columns" do
          subject.cat.shards({:v => true}).as(String).should match /^index/
        end
      end
    end
  end
end
