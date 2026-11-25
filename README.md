![Travis](https://travis-ci.org/paktek123/elasticsearch-crystal.svg?branch=master) 

<a href="https://www.buymeacoffee.com/neeran" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>

# Elasticsearch-crystal

Elasticsearch Library for Crystal Lang. Heavily inspired by Ruby Elasticsearch Library.

## Installation

```
dependencies:
  elasticsearch-crystal:
    github: paktek123/elasticsearch-crystal
    version: ~> 0.14
```

## Usage

```
require "elasticsearch-crystal/elasticsearch/api"

client = Elasticsearch::API::Client.new({:host => "localhost", :port => 9250})

# create an index
client.indices.create({:index => "test_index", :body => {"mappings" => {"type_1" => {} of String => String}}})
client.cat.indices

# For getting back JSON 

client.cat.indices({:format => "json"}).as(JSON::Any)
```

For more example see under the `test` folder

## Elasticsearch 8.x / 9.x compatibility mode

Set `:compatibility_version` to the major version of your server to send versioned media types
(`application/vnd.elasticsearch+json; compatible-with=8`) in the `Accept` header, and in `Content-Type` for requests with
a body (GET, POST, PUT). `bulk` uses `application/vnd.elasticsearch+x-ndjson; compatible-with=N`. Responses with
`application/vnd.elasticsearch+json` are parsed as JSON.

```
client = Elasticsearch::API::Client.new({:host => "localhost", :port => 9200, :compatibility_version => 8})
```

When `:compatibility_version` is set, the first successful response must carry `X-Elastic-Product: Elasticsearch`,
otherwise `Elasticsearch::UnsupportedProductError` is raised. Pass `:verify_product => 0` to disable this check, or
`:verify_product => 1` to enable it without compatibility mode (needs Elasticsearch 7.14+). Without these settings,
behaviour is unchanged.

## Roadmap

Right now this although covers most of the Elasticsearch API, still lacks certain functionality. The next features will be driven by community demand.
- Make the repo more 'Crystal' Lang style, it follows ruby conventions or no conventions at all right now
- Code is a bit repetitive in places
- Same functionality as the Ruby Elasticsearch Library

## Issues and Bugs

Although there is a test suite of Elasticsearch there are bound to be many bugs. Please raise an issue with steps to reproduce and any stack traces. Contributions are welcome to fix.

## Contribute

Contributions are welcome!

- Run a local Elasticsearch on port 9250: `docker run -d -p 9250:9200 elasticsearch:5.2`

- Run the test suite interested in `crystal spec test/integation/cat/*`

- Fork the repo and work on your feature in a branch

- Make a PR
