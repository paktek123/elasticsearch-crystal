# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed
- **Behaviour change:** 4xx/5xx responses now raise typed errors (`Elasticsearch::BadRequestError`, `AuthenticationError`, `AuthorizationError`, `NotFoundError`, `ConflictError`, or `ApiError` for other statuses) instead of being returned as a normal result. Code that inspected the returned hash for errors must now rescue these, or pass `ignore: 404` (or an array of statuses).
- **Behaviour change:** socket and IO failures now raise `Elasticsearch::ConnectionError` / `Elasticsearch::ConnectionTimeout` instead of `Socket::ConnectError` / `IO::TimeoutError`. `ping` returns `false` for these.

### Added
- `Elasticsearch::Error` and `Elasticsearch::ApiError` (with `status`, `body`, `error_type`, `reason`).
- The `ignore` option now works on every action and is no longer sent to Elasticsearch as a query parameter.
