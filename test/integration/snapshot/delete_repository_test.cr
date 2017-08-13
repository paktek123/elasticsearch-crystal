require "../../spec_helper"

module Elasticsearch
  module Test
    class SnapshotDeleteRepositoryTest
      include Spec

      context "Snapshot: Delete Repository: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Delete Repository" do
          subject.snapshot.create_repository({:repository => "test_cat_repo_1", :body => {"type" => "fs", 
                                                                                          "settings" => {"location" => "test_cat_repo_1_loc"}}})
          subject.snapshot.delete_repository({:repository => "test_cat_repo_1"})
        end
      end
    end
  end
end
