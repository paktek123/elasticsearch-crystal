require "../../spec_helper"

module Elasticsearch
  module Test
    class CatThreadPoolTest
      include Spec

      context "Cat: Thread Pool: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "help" do
          subject.cat.thread_pool({:help => true}).as(String).should match /thread/
        end

        it "should return thread pools" do
          subject.cat.thread_pool.as(String).should match /bulk/
        end

        it "check thread pool are not empty with columns" do
          subject.cat.thread_pool({:v => true}).as(String).should match /^node/
        end
      end
    end
  end
end
