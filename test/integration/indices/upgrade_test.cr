require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesUpgradeTest
      include Spec

      context "Indices: Upgrade: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "upgrade an index" do
          subject.indices.create({:index => "test"})
          subject.indices.upgrade({:index => "test"})
        end
      end
    end
  end
end
