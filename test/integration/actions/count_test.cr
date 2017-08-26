require "../../spec_helper"

module Elasticsearch
  module Test
    class ActionsCountTest
      include Spec

      context "Actions: Count: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Count all documents" do
          subject.count
        end
      end
    end
  end
end
