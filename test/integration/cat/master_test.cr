require "../../spec_helper"

module Elasticsearch
  module Test
    class CatMasterTest
      include Spec

      context "Cat: Master: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "master" do
          (subject.cat.master.as(String).empty?).should be_false
        end
      end
    end
  end
end
