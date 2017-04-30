require "../../spec_helper"

module Elasticsearch
  module Test
    class CatNodeAttrsTest
      include Spec

      context "Cat: NodeAttrs: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "help" do
          subject.cat.nodeattrs({:help => true}).as(String).should match /node/
        end

        it "check attrs are not empty" do
          (subject.cat.nodeattrs.as(String).empty?).should be_false
        end

        it "check attrs are not empty with columns" do
          subject.cat.nodeattrs({:v => true}).as(String).should match /^node/
        end
      end
    end
  end
end
