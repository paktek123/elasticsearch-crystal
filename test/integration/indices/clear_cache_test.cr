require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesClearCacheTest
      include Spec

      context "Indices: Clear Cache: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "clear all caches" do
          subject.indices.clear_cache
        end

        it "clean fields for an index" do
          subject.indices.create({:index => "test"})
          subject.indices.clear_cache({:index => "test", :fields => true})
        end
      end
    end
  end
end
