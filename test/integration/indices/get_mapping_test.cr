require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesGetMappingTest
      include Spec

      context "Indices: Get Mapping: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "delete a mapping" do
          subject.indices.create({:index => "test", :body => {"mappings" => {"type_1" => {} of String => String}}})
          subject.indices.get_mapping({:index => "test", :type => "type_1"})
        end
      end
    end
  end
end
