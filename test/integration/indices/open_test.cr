require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesOpenTest
      include Spec

      context "Indices: Open: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "open an index" do
          subject.indices.create({:index => "test"})
          subject.indices.open({:index => "test"})
          subject.cat.indices.as(String).should match /open/
        end
      end
    end
  end
end
