require "../../spec_helper"

module Elasticsearch
  module Test
    class SnapshotCreateTest
      include Spec

      context "Snapshot: Create : " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.snapshot.delete_repository({:repository => "test_cat_repo_1"})
        end

        it "Create Repository" do
          subject.snapshot.create_repository({:repository => "test_cat_repo_1", :body => {"type" => "fs", 
                                                                                          "settings" => {"location" => "test_cat_repo_1_loc"}}})
          subject.snapshot.create({:repository => "test_cat_repo_1", :snapshot => "snap1", :wait_for_completion => true})
        end
      end
    end
  end
end
