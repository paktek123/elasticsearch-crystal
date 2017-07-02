require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesGetWarmerTest
      include Spec

      context "Indices: Get Warmer: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "get a warmer" do
          subject.indices.create({:index => "test"})
          subject.indices.put_warmer({:index => "test", :name => "main", :body => { "query" => { 
                                                                                      "filtered" => { 
                                                                                        "filter" => { 
                                                                                          "term" => { "published" => true } 
                                                                                        } 
                                                                                      } 
                                                                                    },
                                                                                    "sort" => [ "created_at" ]
                                                                                  }})
          subject.indices.get_warmer({:index => "test", :name => "main"})
          subject.indices.delete_warmer({:index => "test", :name => "main"})
        end
      end
    end
  end
end
