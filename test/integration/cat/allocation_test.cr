require "../../spec_helper"

module Elasticsearch
  module Test
    class CatAllocationTest
      include Spec

      context "Cat: Allocation" do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "help" do
          subject.cat.allocation({:help => true}).should match /^shards/
        end

        it "one index" do
          subject.indices.create({:index => "test"})
          subject.cat.allocation.as(String).should match /UNASSIGNED/
        end

        it "node id" do
          subject.indices.create({:index => "test"})
          subject.cat.allocation({:node_id => "_master"}).should match /UNASSIGNED/
        end

        it "all nodes" do
          subject.indices.create({:index => "test"})
          subject.cat.allocation({:node_id => "*"}).should match /UNASSIGNED/
        end

        it "column headers" do
          subject.cat.allocation({:v => true}).should match /^shards/
        end

        it "select columns" do
          subject.cat.allocation({:h => "disk.percent,node", :v => true}).should match /^disk\.percent/
        end
      end
    end
  end
end
