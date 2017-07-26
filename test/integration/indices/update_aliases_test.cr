require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesUpdateAliasesTest
      include Spec

      context "Indices: Update Aliases: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "testind"})
        end

        it "update an alias" do
          subject.indices.create({:index => "testind"})
          subject.indices.put_alias({:index => "testind", :name => "testali"})
          subject.cat.aliases.as(String).should match /testali/
          subject.indices.update_aliases({:body => {"actions" => [
                                                      {"remove" => {"index" => "testind", "alias" => "testali"}},
                                                      {"add" => {"index" => "testind", "alias" => "testali2"}},
                                                    ]}})
          subject.indices.delete_alias({:index => "testind", :name => "testali2"})
          (subject.cat.aliases.as(String).empty?).should be_true 
        end
      end
    end
  end
end
