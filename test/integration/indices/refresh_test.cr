require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesRefreshTest
      include Spec

      context "Indices: Refresh: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "refresh an index" do
          subject.indices.create({:index => "test"})
          subject.indices.refresh({:index => "test"})
        end
      end
    end
  end
end
