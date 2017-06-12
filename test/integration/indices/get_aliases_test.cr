require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesGetAliasesTest
      include Spec

      context "Indices: Get Aliases: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "testind1"})
          subject.indices.delete({:index => "testind2"})
        end

        it "get an alias" do
          subject.indices.create({:index => "testind1"})
          subject.indices.create({:index => "testind2"})
          subject.indices.put_alias({:index => "testind1", :name => "testali1"})
          subject.indices.put_alias({:index => "testind2", :name => "testali2"})
          subject.indices.get_aliases({:index => "testind1,testind2", :name => "testali1,testali2"})
          subject.indices.delete_alias({:index => "testind1", :name => "testali1"}) 
          subject.indices.delete_alias({:index => "testind2", :name => "testali2"})
        end
      end
    end
  end
end
