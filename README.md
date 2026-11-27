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

## Error handling

Responses with a 4xx/5xx status raise a typed error instead of being returned as a normal result:

| Status | Error |
| --- | --- |
| 400 | `Elasticsearch::BadRequestError` |
| 401 | `Elasticsearch::AuthenticationError` |
| 403 | `Elasticsearch::AuthorizationError` |
| 404 | `Elasticsearch::NotFoundError` |
| 409 | `Elasticsearch::ConflictError` |
| other 4xx/5xx | `Elasticsearch::ApiError` |

All of these inherit from `Elasticsearch::ApiError` (itself an `Elasticsearch::Error`) and expose `status`, `body` (parsed response), `error_type` and `reason`. Connection failures raise `Elasticsearch::ConnectionError`, and timeouts raise `Elasticsearch::ConnectionTimeout`.

```crystal
begin
  client.get({:index => "test_index", :type => "_doc", :id => "1"})
rescue e : Elasticsearch::NotFoundError
  puts e.status, e.error_type, e.reason
end

# Suppress errors for given statuses and get the response body back
client.get({:index => "test_index", :type => "_doc", :id => "1", :ignore => 404})
client.delete({:index => "test_index", :type => "_doc", :id => "1", :ignore => [404, 409]})
```

`exists`, `indices.exists` and the other `exists*` actions, as well as `ping`, keep returning `true`/`false`.

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
