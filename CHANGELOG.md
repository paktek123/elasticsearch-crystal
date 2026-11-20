# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- `crystal` version constraint in `shard.yml`.

### Removed

- Unused `spec2` development dependency.

### Fixed

- `src/elasticsearch.cr` now uses a relative require so the library builds in-repo.
