require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesGetAliasTest
      include Spec

      context "Indices: Get Alias: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "testind"})
        end

        it "get an alias" do
          subject.indices.create({:index => "testind"})
          subject.indices.put_alias({:index => "testind", :name => "testali"})
          subject.indices.get_alias({:index => "testind", :name => "testali"})
          subject.indices.delete_alias({:index => "testind", :name => "testali"}) 
        end
      end
    end
  end
end
