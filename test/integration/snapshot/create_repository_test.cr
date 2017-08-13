require "../../spec_helper"

module Elasticsearch
  module Test
    class SnapshotCreateRepositoryTest
      include Spec

      context "Snapshot: Create Repository: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.snapshot.delete_repository({:repository => "test_cat_repo_1"})
        end

        it "Create Repository" do
          subject.snapshot.create_repository({:repository => "test_cat_repo_1", :body => {"type" => "fs", 
                                                                                          "settings" => {"location" => "test_cat_repo_1_loc"}}})
        end
      end
    end
  end
end
