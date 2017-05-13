require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesDeleteMappingTest
      include Spec

      context "Indices: Delete Mapping: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "delete an alias" do
          subject.indices.create({:index => "testind"})
          subject.indices.put_alias({:index => "testind", :name => "testali"})
          subject.cat.aliases.as(String).should match /testali/
          subject.indices.delete_alias({:index => "testind", :name => "testali"})
          (subject.cat.aliases.as(String).empty?).should be_true 
        end
      end
    end
  end
end
