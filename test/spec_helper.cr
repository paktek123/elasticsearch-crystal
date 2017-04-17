require "../src/elasticsearch/api"
require "spec"
require "json"
require "yaml"

module Elasticsearch
  module Test
    class Client < Elasticsearch::API::Client
      def initialize(@settings : Hash(Symbol, Int32 | String))
        super
      end
    end
  end
end



#def run_test()
c = YAML.parse_all(File.read("tmp/elasticsearch/rest-api-spec/src/main/resources/rest-api-spec/test/indices.create/10_basic.yaml"))
  
  #puts 
macro generate_test(data)
  {% for blah in data %}
  {% for test_name, steps in blah %}
  context {{test_name.id}} do
    it should {{test_name.id}} do
      {% for action, params in steps %}
      {% if action == "do" %}
      {% for method, args in params %}
      result = subject.{{method.id}}({{args.id}})
      {% end %}
      {% end %}
      {% if action == "match" %}
      result.should match {{steps["match"].id}}
      {% end %}
      {% end %}
    end
  end
  {% end %}
  {% end %}
end

generate_test(c)
  
#end
  #c.each |test| do
  #  test.each do |test_name,steps|
  #    steps.each do |action, params|
  #      if action == "do"
  #        params.each do |method, 
  #        {% for method in params %}
  #    }

