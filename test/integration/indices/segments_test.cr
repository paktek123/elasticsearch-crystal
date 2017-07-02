require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesSegmentsTest
      include Spec

      context "Indices: Segments: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "recover segments information" do
          subject.indices.create({:index => "test"})
          subject.indices.segments({:index => "test"})
        end
      end
    end
  end
end
