require "../../spec_helper"

module Elasticsearch
  module Test
    class IngestGetPipelineTest
      include Spec

      context "Ingest: Get Pipeline: " do
        subject = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

        Spec.after_each do
          subject.ingest.delete_pipeline({:id => "test"})
        end

        it "Delete a pipeline" do
          subject.ingest.put_pipeline({:id => "test", :body => {"description" => "describe pipeline", 
                                                                "processors" => [{"set" => {"field"=>"foo","value"=>"bar"}}]}})
          subject.ingest.get_pipeline({:id => "test"})
        end
      end
    end
  end
end
