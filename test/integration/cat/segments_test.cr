require "../../spec_helper"

module Elasticsearch
  module Test
    class CatSegmentsTest
      include Spec

      context "Cat: Segments: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "help" do
          subject.cat.segments({:help => true}).as(String).should match /segment/
        end

        it "check segments are not empty with columns" do
          subject.cat.segments({:v => true}).as(String).should match /segment/
        end
      end
    end
  end
end
