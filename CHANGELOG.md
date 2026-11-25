# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- `scroll` action: `POST /_search/scroll` with `scroll_id` and `scroll` sent in the request body; supports the `rest_total_hits_as_int` query parameter.
- `clear_scroll` accepts a body (`{"scroll_id" => [...]}`) as well as `scroll_id: "_all"`.
- Unit specs (`test/unit`) that verify the request sent, using a local `HTTP::Server`.

### Changed

- Transport: `DELETE` requests now forward a non-empty request body.
- Transport: `POST` requests now send query parameters, and `POST`/`PUT`/`DELETE` send `Content-Type: application/json`.
