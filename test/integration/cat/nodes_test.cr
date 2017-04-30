require "../../spec_helper"

module Elasticsearch
  module Test
    class CatNodesTest
      include Spec

      context "Cat: Nodes: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "help" do
          subject.cat.nodes({:help => true}).as(String).should match /heap\.percent/
        end

        it "check nodes are not empty" do
          (subject.cat.nodes.as(String).empty?).should be_false
        end

        it "check nodes are not empty with columns" do
          subject.cat.nodes({:v => true}).as(String).should match /^ip/
        end
      end
    end
  end
end
