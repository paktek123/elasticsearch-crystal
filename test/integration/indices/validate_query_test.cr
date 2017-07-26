require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesValidateQueryTest
      include Spec

      context "Indices: ValidateQuery: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "validate a query" do
          subject.indices.create({:index => "test"})
          subject.indices.validate_query({:index => "test", :q => "title:foo AND body:bar"})
        end
      end
    end
  end
end
