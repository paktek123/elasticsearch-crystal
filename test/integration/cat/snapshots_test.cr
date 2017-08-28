require "../../spec_helper"

module Elasticsearch
  module Test
    class CatSnapshotsTest
      include Spec

      context "Cat: Snapshots: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "index1"})
          subject.indices.delete({:index => "index2"})
          subject.snapshot.delete({:repository => "test_cat_repo_1", :snapshot => "snap1"})
          #subject.snapshot.delete({:repository => "test_cat_repo_1", :snapshot => "snap2"})
          subject.snapshot.delete_repository({:repository => "test_cat_repo_1"})
        end

        it "help" do
          subject.cat.repositories({:help => true}).as(String).should match /^id/
        end

        it "should return repositories when created" do
          (subject.cat.repositories.as(String).empty?).should be_true
          subject.snapshot.create_repository({:repository => "test_cat_repo_1", :body => {"type" => "fs", 
                                                                                          "settings" => {"location" => "test_cat_repo_1_loc"}}})
          subject.cat.snapshots({:repository => "test_cat_repo_1"})
          subject.indices.create({:index => "index1", :body => {"settings" => {"number_of_shards" => "1", 
                                                                               "number_of_replicas" => "0"}}})
          subject.indices.create({:index => "index2", :body => {"settings" => {"number_of_shards" => "1", 
                                                                               "number_of_replicas" => "0"}}})
          subject.cluster.health({:wait_for_status => "green"})
          subject.snapshot.create({:repository => "test_cat_repo_1", :snapshot => "snap1", :wait_for_completion => true})
          #subject.snapshot.create({:repository => "test_cat_repo_1", :snapshot => "snap2", :wait_for_completion => true})
          subject.cat.snapshots({:repository => "test_cat_repo_1"}).as(JSON::Any)
          #subject.cat.snapshots({:repository => "test_cat_repo_1"}).as(String).should match /snap2/
        end
      end
    end
  end
end
