require "../../spec_helper"

module Elasticsearch
  module Test
    class CatCountTest
      include Spec

      context "Cat: Count: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.indices.delete({:index => "index1"})
          #subject.indices.delete({:index => "index2"})
        end

        it "help" do
          subject.cat.count({:help => true}).should match /^epoch/
        end

        it "test count" do
          subject.cat.count.should match /.*0/
          #subject.index({:index => "index1", :type => "type1", :id => "1", :body => {"foo" => "bar"}, :refresh => true})
          #subject.cat.count.should match /.*1/
          #subject.index({:index => "index2", :type => "type2", :id => "1", :body => {"foo" => "bar"}, :refresh => true})
          #subject.cat.count.should match /.*2/
          # shard allocation exception I need to dig into this
          subject.cat.count({:h => "count", :v => true}).should match /^count/
          #subject.cat.count({:index => "index1"}).should match /.*1/
          #subject.cat.count({:index => "index2"}).should match /(?=.*2)(?=.*epoch)/
        end
      end
    end
  end
end
