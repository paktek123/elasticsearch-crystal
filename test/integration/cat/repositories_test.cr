require "../../spec_helper"

module Elasticsearch
  module Test
    class CatRepositoriesTest
      include Spec

      context "Cat: Repositories: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.snapshot.delete_repository({:repository => "test_cat_repo_1"})
          subject.snapshot.delete_repository({:repository => "test_cat_repo_2"})
        end

        it "help" do
          subject.cat.repositories({:help => true}).as(String).should match /^id/
        end

        it "should return repositories when created" do
          (subject.cat.repositories.as(String).empty?).should be_true
          subject.snapshot.create_repository({:repository => "test_cat_repo_1", :body => {"type" => "fs", 
                                                                                          "settings" => {"location" => "test_cat_repo_1_loc"}}})
          subject.snapshot.create_repository({:repository => "test_cat_repo_2", :body => {"type" => "fs", 
                                                                                          "settings" => {"location" => "test_cat_repo_2_loc"}}})
          subject.cat.repositories.should match /test_cat_repo_1/
          subject.cat.repositories.should match /test_cat_repo_2/
        end
      end
    end
  end
end
