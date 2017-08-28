require "../../spec_helper"

module Elasticsearch
  module Test
    class CatTemplatesTest
      include Spec

      context "Cat: Templates: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete_template({:name => "test"})
          subject.indices.delete_template({:name => "test_2"})
        end

        it "help" do
          subject.cat.templates({:help => true}).as(String).should match /template/
        end

        it "should create a normal template" do
          #(subject.cat.templates.as(String).empty?).should be_true
          subject.indices.put_template({:name => "test", :body => {"order" => 0, 
                                                                   "version" => 1, 
                                                                   "template" => "test",
                                                                   "index_patterns" => "test-*",
                                                                   "settings" => {"number_of_shards" => "1", 
                                                                                  "number_of_replicas" => "0"}}})
          subject.indices.put_template({:name => "test_2", :body => {"order" => 1, 
                                                                     "version" => 2, 
                                                                     "template" => "test_2",
                                                                     "index_patterns" => "test-2*",
                                                                     "settings" => {"number_of_shards" => "1", 
                                                                                    "number_of_replicas" => "0"}}})
          subject.cat.templates.as(String).should match /(?=.*test)(?=.*test_2)/
        end

        it "should template with no match" do
          #(subject.cat.templates.as(String).empty?).should be_true
          subject.indices.put_template({:name => "test", :body => {"order" => 0, 
                                                                   "version" => 1, 
                                                                   "template" => "test",
                                                                   "index_patterns" => "t*",
                                                                   "settings" => {"number_of_shards" => "1", 
                                                                                  "number_of_replicas" => "0"}}})
          subject.indices.put_template({:name => "nomatch", :body => {"order" => 1, 
                                                                     "version" => 2, 
                                                                     "template" => "test_2",
                                                                     "index_patterns" => "tea*",
                                                                     "settings" => {"number_of_shards" => "1", 
                                                                                    "number_of_replicas" => "0"}}})
          subject.cat.templates({:name => "test*"}).as(String).should match /(?=.*test)/
        end

        it "check tasks are not empty with columns" do
          subject.cat.templates({:v => true}).as(String).should match /^name/
        end
      end
    end
  end
end
