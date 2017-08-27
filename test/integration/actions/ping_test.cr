require "../../spec_helper"

module Elasticsearch
  module Test
    class ActionsPingTest
      include Spec

      context "Actions: Ping: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Ping test" do
          subject.ping
        end
      end
    end
  end
end
