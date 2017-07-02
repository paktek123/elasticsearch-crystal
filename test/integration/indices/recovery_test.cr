require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesRecoveryTest
      include Spec

      context "Indices: Recovery: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "recover an index information" do
          subject.indices.create({:index => "test"})
          subject.indices.recovery({:index => "test"})
        end
      end
    end
  end
end
