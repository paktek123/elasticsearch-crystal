require "../../spec_helper"

module Elasticsearch
  module Test
    class CatHelpTest
      include Spec

      context "Cat: Help: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "help" do
          (subject.cat.help.as(String).empty?).should be_false
        end
      end
    end
  end
end
