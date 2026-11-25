# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- `:compatibility_version` client setting sends `Accept`/`Content-Type` `application/vnd.elasticsearch+json; compatible-with=N` (and `+x-ndjson` for `bulk`) for Elasticsearch 8.x/9.x (#18).
- `X-Elastic-Product` verification with new `Elasticsearch::UnsupportedProductError`; controlled by the `:verify_product` setting (#18).

### Changed

- Responses with `Content-Type: application/vnd.elasticsearch+json` are parsed as JSON (#18).
- Request headers are built once and passed to every HTTP method (#18).
