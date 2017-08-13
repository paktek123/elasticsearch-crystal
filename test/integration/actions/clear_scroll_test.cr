require "../../spec_helper"

module Elasticsearch
  module Test
    class ActionsClearScrollTest
      include Spec

      context "Actions: Clear Scroll: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        it "Clear a scroll" do
          subject.clear_scroll({:body => {} of Symbol => String, :scroll_id => "_all"})
        end
      end
    end
  end
end
