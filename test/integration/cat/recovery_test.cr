require "../../spec_helper"

module Elasticsearch
  module Test
    class CatRecoveryTest
      include Spec

      context "Cat: Recovery: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "help" do
          subject.cat.recovery({:help => true}).as(String).should match /index/
        end

        it "check recovery are not empty with columns" do
          subject.cat.nodes({:v => true}).as(String).should match /cpu/
        end
      end
    end
  end
end
