require "../../spec_helper"

module Elasticsearch
  module Test
    class CatAliasesTest
      #include Spec2
      #include Spec2::GlobalDSL

      context "Cat: Aliases" do

        subject = FakeClient.new
        #subject = double(FakeClient.new, { :perform_request => FakeResponse.new })
        #Mocks.create_mock FakeClient do
        #  mock self.perform_request("GET", "_cat/aliases", {} of Char => Char, nil)
        #end

        #allow(FakeClient).to receive(self.perform_request("GET", "_cat/aliases", {} of Char => Char, nil).and_return(FakeResponse.new)

        #subject = Mocks.instance_double(FakeClient, 
        #                             returns(perform_request("GET", "_cat/aliases", {} of Char => Char, nil), 
        #                             FakeResponse))
        #subject = FakeClient.new
        #allow(subject).to receive(perform_request("GET", "_cat/aliases", {} of Char => Char, nil)).and_return(FakeResponse.new)

        it "should perform correct request" do
          #subject.perform_request "GET", "_cat/aliases", {} of Char => Char, nil
          #subject = double(FakeClient.new, { :perform_request => FakeResponse.new })
          #subject = double()

          #subject.stub(:perform_request).
          #with("GET", "_cat/aliases", {} of Char => Char, nil).
          #and_return(FakeResponse.new)

          #  assert_equal "GET", method
          #  assert_equal "_cat/aliases", url
          #  assert_equal Hash.new, params
          #  assert_nil   body
          #  true
          #end.returns(FakeResponse.new)

          subject.cat.aliases
        end

      end

    end
  end
end
