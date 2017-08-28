# Elasticsearch-crystal

Elasticsearch Library for Crystal Lang. Heavily inspired by Ruby Elasticsearch Library.

## Installation

```
dependencies:
  elasticsearch-crystal:
    github: paktek123/elasticsearch-crystal
    version: ~> 0.11
```

## Usage

```
require "elasticsearch/api"

client = Elasticsearch::API::Client.new({:host => "localhost", :port => 9250})

# create an index
client.indices.create({:index => "test_index", :body => {"mappings" => {"type_1" => {} of String => String}}})
client.cat.indices

# For getting back JSON 

client.cat.indices({:format => "json"}).as(JSON::Any)
```

For more example see under the `test` folder

## Roadmap

Right now this although covers most of the Elasticsearch API, still lacks certain functionality. The next features will be driven by community demand.

## Contribute

Contributions are welcome!

- Run a local Elasticsearch on port 9250: `docker run -d -p 9250:9200 elasticsearch:5.2`

- Run the test suite interested in `crystal spec test/integation/cat/*`

- Fork the repo and work on your feature in a branch

- Make a PR
