require "../../spec_helper"

module Elasticsearch
  module Test
    class CatHealthTest
      include Spec

      context "Cat: Health: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "help" do
          subject.cat.health({:help => true}).should match /status/
        end

        it "test field data output" do
          subject.cat.health.should match /(green|yellow)/
        end
      end
    end
  end
end
