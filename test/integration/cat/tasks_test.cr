require "../../spec_helper"

module Elasticsearch
  module Test
    class CatTasksTest
      include Spec

      context "Cat: Tasks: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "help" do
          subject.cat.tasks({:help => true}).as(String).should match /transport/
        end

        it "check tasks are not empty with columns" do
          subject.cat.tasks({:v => true}).as(String).should match /^action/
        end
      end
    end
  end
end
