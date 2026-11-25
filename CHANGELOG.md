# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- HTTPS/TLS support and HTTP basic authentication (#15), needed for default Elasticsearch 8.x/9.x clusters.
  New client settings: `:scheme`, `:user`, `:password`, `:ca_file`, `:verify` and `:url`
  (e.g. `https://user:pass@host:9200`). `:host` now defaults to `localhost` and `:port` to `9200`.
- README section "Connecting to a secured cluster".
- Unit specs for URL/header construction and an optional integration spec for secured clusters
  (`test/integration/secured`, runs when `ELASTIC_PASSWORD` is set).

### Changed
- The client settings hash type is now `Hash(Symbol, String | Int32 | Bool)`; existing
  `{:host => ..., :port => ...}` literals keep working.
- All requests now send `Content-Type: application/json` (required by Elasticsearch 8+ for requests with a body).
- Client `inspect`/`to_s` no longer print the settings, so credentials are not leaked.
