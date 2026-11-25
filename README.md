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

## Connecting to a secured cluster

Since Elasticsearch 8.0 security is enabled by default: a fresh cluster serves HTTPS with a self-signed CA and requires authentication (Elastic Cloud works the same way). Use the following settings:

| Setting     | Description                                                              | Default     |
|-------------|--------------------------------------------------------------------------|-------------|
| `:url`      | Full URL, e.g. `https://user:pass@host:9200` (explicit settings win)      |             |
| `:scheme`   | `"http"` or `"https"`                                                    | `"http"`    |
| `:host`     | Hostname                                                                 | `"localhost"` |
| `:port`     | Port                                                                     | `9200`      |
| `:user`     | Username for HTTP basic authentication                                   |             |
| `:password` | Password for HTTP basic authentication                                   |             |
| `:ca_file`  | Path to a CA certificate (e.g. `http_ca.crt` of a default ES 8/9 install) |             |
| `:verify`   | Verify the server certificate (`true`/`false`)                           | `true`      |

```crystal
require "elasticsearch-crystal/elasticsearch/api"

# Trust the cluster CA (recommended)
client = Elasticsearch::API::Client.new({
  :scheme   => "https",
  :host     => "localhost",
  :port     => 9200,
  :user     => "elastic",
  :password => ENV["ELASTIC_PASSWORD"],
  :ca_file  => "/path/to/http_ca.crt",
})

# Or use a URL
client = Elasticsearch::API::Client.new({:url => "https://elastic:#{ENV["ELASTIC_PASSWORD"]}@localhost:9200", :ca_file => "/path/to/http_ca.crt"})

# Development only: skip certificate verification
client = Elasticsearch::API::Client.new({:url => "https://localhost:9200", :user => "elastic", :password => "...", :verify => false})
```

Passwords are never included in `inspect`/`to_s` output of the client or in exceptions raised by it. Note that a password embedded in `:url` must be URL-encoded. API key, bearer token and Cloud ID authentication are not supported yet.

Supported with Elasticsearch 7.x (secured), 8.x and 9.x.

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
