require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesPutMappingTest
      include Spec

      context "Indices: Put Mapping: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "put a mapping" do
          subject.indices.create({:index => "test"})
          subject.indices.put_mapping({:index => "test", :type => "type_1", :body => {"type_1" => {} of String => String}})
          subject.indices.delete_mapping({:index => "test", :type => "type_1"})
        end
      end
    end
  end
end
