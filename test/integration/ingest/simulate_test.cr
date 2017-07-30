require "../../spec_helper"

module Elasticsearch
  module Test
    class IngestSimulatePipelineTest
      include Spec

      context "Ingest: Simulate Pipeline: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.ingest.delete_pipeline({:id => "test"})
        end

        it "Delete a pipeline" do
          subject.ingest.simulate({:id => "test", :body => {"description" => "describe pipeline", 
                                                            "processors" => [{"set" => {"field"=>"foo","value"=>"bar"}}]}})
        end
      end
    end
  end
end
