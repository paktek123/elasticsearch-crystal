require "../../spec_helper"

module Elasticsearch
  module Test
    class ActionsScrollTest
      include Spec

      context "Actions: Scroll: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test_scroll_index"})
        end

        it "should page through all documents with scroll, then clear the scroll" do
          total = 7
          subject.indices.create({:index => "test_scroll_index"})
          (1..total).each do |i|
            subject.index({:index => "test_scroll_index",
                           :type  => "_doc",
                           :id    => i.to_s,
                           :body  => {"title" => "Test #{i}"}})
          end
          subject.indices.refresh({:index => "test_scroll_index"})

          response = subject.search({:index  => "test_scroll_index",
                                     :scroll => "1m",
                                     :size   => "3",
                                     :body   => {"query" => {"match_all" => {} of String => String}}}).as(JSON::Any)

          seen = 0
          scroll_id = response["_scroll_id"].as_s
          hits = response["hits"]["hits"].as_a

          while !hits.empty?
            seen += hits.size
            response = subject.scroll({:scroll_id => scroll_id, :scroll => "1m"}).as(JSON::Any)
            scroll_id = response["_scroll_id"].as_s
            hits = response["hits"]["hits"].as_a
          end

          seen.should eq total

          subject.clear_scroll({:body => {"scroll_id" => [scroll_id]}})
        end

        it "should clear all scrolls with scroll_id _all" do
          subject.clear_scroll({:scroll_id => "_all"})
        end
      end
    end
  end
end
