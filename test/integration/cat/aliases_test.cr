require "../../spec_helper"

module Elasticsearch
  module Test
    class CatAliasesTest
      include Spec

      context "Cat: Aliases" do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete_alias({:index => "test", :name => "test_alias"})
          subject.indices.delete_alias({:index => "test", :name => "test_1"})
          subject.indices.delete_alias({:index => "test", :name => "test_2"})
          subject.indices.delete({:index => "test"})
          subject.indices.delete({:index => "test_index"})
        end

        it "should return help page" do
          subject.cat.aliases({:help => true}).should match /^alias/
        end

        it "check for empty aliases" do
          (subject.cat.aliases.as(String).empty?).should be_true
        end 

        it "should create new alias" do
          subject.indices.create({:index => "test"})
          subject.indices.put_alias({:index => "test", :name => "test_alias"})
          subject.cat.aliases.should match /^test_alias/
        end

        it "should create a complex alias" do 
          subject.indices.create({:index => "test", :body => {"mappings" => {
                                                                "type1" => {
                                                                  "properties" => {
                                                                    "foo" => {
                                                                      "type" => "text"
                                                                      }
                                                                    }
                                                                  } 
                                                                }
                                                              }})
          subject.indices.put_alias({:index => "test", :name => "test_alias", :body => {"index_routing" => "ir", 
                                                                                "search_routing" => "sr1,sr2",
                                                                                "filter" => {
                                                                                  "term" => {
                                                                                    "foo" => "bar"
                                                                                    }
                                                                                  }
                                                                                }})
          subject.cat.aliases.should match /sr1,sr2/
        end

        it "should create an alias with the correct name" do
          subject.indices.create({:index => "test"})
          subject.indices.put_alias({:index => "test", :name => "test_1"})
          subject.indices.put_alias({:index => "test", :name => "test_2"})
          subject.cat.aliases.should match /test_1/
          subject.cat.aliases.should match /test_2/
          subject.cat.aliases({:name => "test_*"}).should match /(test_1|test_2)/
        end

        it "should return the verbose columns" do
          subject.indices.create({:index => "test"})
          subject.indices.put_alias({:index => "test", :name => "test_1"})
          subject.cat.aliases({:v => true}).should match /routing\.index/
        end

        it "should return the correct columns" do
          subject.indices.create({:index => "test"})
          subject.indices.put_alias({:index => "test", :name => "test_1"})
          subject.cat.aliases({:h => "index,alias", :v => true}).should match /test_1/
        end

        it "should create alias against closed index" do
          subject.indices.create({:index => "test_index", :body => {"aliases" => {"test_alias" => {} of String => String}}})
          subject.indices.close({:index => "test_index"})
          subject.cat.aliases.should match /test_index/
        end

        it "should return correct JSON" do
          subject.indices.create({:index => "test"})
          subject.indices.put_alias({:index => "test", :name => "test_alias"})
          subject.cat.aliases({:format => "json"})
        end
      end
    end
  end
end
