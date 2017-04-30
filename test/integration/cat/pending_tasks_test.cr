require "../../spec_helper"

module Elasticsearch
  module Test
    class CatPendingTasksTest
      include Spec

      context "Cat: PendingTasks: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "help" do
          subject.cat.pending_tasks({:help => true}).as(String).should match /insertOrder/
        end

        it "should be not empty tasks" do
          (subject.cat.pending_tasks.as(String).empty?).should be_true
        end

        it "check pending_tasks are not empty with columns" do
          subject.cat.pending_tasks({:v => true}).as(String).should match /^insertOrder/
        end
      end
    end
  end
end
