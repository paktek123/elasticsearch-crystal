require "../../spec_helper"

module Elasticsearch
  module Test
    class TasksListTest
      include Spec

      context "Tasks: List: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "List Tasks" do
          subject.tasks.list
        end
      end
    end
  end
end
