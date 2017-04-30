require "../../spec_helper"

module Elasticsearch
  module Test
    class CatPluginsTest
      include Spec

      context "Cat: Plugins: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "help" do
          subject.cat.plugins({:help => true}).as(String).should match /^id/
        end
      end
    end
  end
end
