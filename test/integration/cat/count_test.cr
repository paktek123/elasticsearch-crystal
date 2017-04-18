require "../../spec_helper"

module Elasticsearch
  module Test
    class CatCountTest
      include Spec

      context "Cat: Count: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          #subject.indices.delete({:index => "test"})
        end

        it "help" do
          subject.cat.count({:help => true}).should match /^epoch/
        end

        it "test count" do
          subject.cat.count.should match /.*0/
        end
      end
    end
  end
end
