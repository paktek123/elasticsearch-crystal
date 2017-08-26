require "../../spec_helper"

module Elasticsearch
  module Test
    class ActionsInfoTest
      include Spec

      context "Actions: Info: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Show cluster info" do
          subject.info
        end
      end
    end
  end
end
