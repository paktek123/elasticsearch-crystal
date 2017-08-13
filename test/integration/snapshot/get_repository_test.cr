require "../../spec_helper"

module Elasticsearch
  module Test
    class SnapshotGetRepositoryTest
      include Spec

      context "Snapshot: Get Repository: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.snapshot.delete_repository({:repository => "test_cat_repo_1"})
        end

        it "Get Repository" do
          subject.snapshot.create_repository({:repository => "test_cat_repo_1", :body => {"type" => "fs", 
                                                                                          "settings" => {"location" => "test_cat_repo_1_loc"}}})
          subject.snapshot.get_repository({:repository => "test_cat_repo_1"})
        end
      end
    end
  end
end
