# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Fixed

- `bulk` now sends its body as NDJSON (one JSON document per line, terminated by a newline) with `Content-Type: application/x-ndjson`, instead of a JSON array that Elasticsearch rejected. It accepts an array of action/source items, the combined format with a `data` key, or a pre-serialised string (sent unchanged). ([#31](https://github.com/paktek123/elasticsearch-crystal/issues/31))
