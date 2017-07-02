require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesSealTest
      include Spec

      context "Indices: Seal: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "seal an index" do
          subject.indices.create({:index => "test"})
          subject.indices.seal({:index => "test"})
        end
      end
    end
  end
end
