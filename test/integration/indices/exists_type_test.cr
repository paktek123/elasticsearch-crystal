require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesExistsTypeTest
      include Spec

      context "Indices: Exists Type: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "type exists" do 
          subject.indices.exists_type({:index => "test", :type => "type_1"}).should be_false
          subject.indices.create({:index => "test", :body => {"mappings" => {"type_1" => {} of String => String}}})
          subject.indices.exists_type({:index => "test", :type => "type_1"}).should be_true
          subject.indices.delete({:index => "test"})
        end
      end
    end
  end
end
