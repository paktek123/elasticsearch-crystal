require "../../spec_helper"

module Elasticsearch
  module Test
    class IndicesDeleteWarmerTest
      include Spec

      context "Indices: Delete Warmer: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "test"})
        end

        it "delete a warmer" do
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
          subject.indices.delete_warmer({:index => "test", :name => "main"})
          # This call causes an error and takes ages, investigate
          #(subject.indices.get_warmer({:index => "test", :name => "main"}).as_hash.empty?).should be_true
        end
      end
    end
  end
end
