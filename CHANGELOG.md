# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Fixed

- Query parameters are now sent for every HTTP method (previously POST, PUT and HEAD dropped them).
- A response without a `Content-Type` header no longer raises `KeyError`.
- Boolean query parameters are sent as `true`/`false` (previously both were sent as an empty value).
- No trailing `?` is appended to the URL when there are no query parameters.
