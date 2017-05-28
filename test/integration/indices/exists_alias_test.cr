require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesExistsAliasTest
      include Spec

      context "Indices: Exists Alias: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it " check if alias exists" do
          subject.indices.create({:index => "test"})
          subject.indices.put_alias({:index => "test", :name => "testali"})
          subject.indices.exists_alias({:index => "test", :name => "testali"}).should be_true 
        end
      end
    end
  end
end
