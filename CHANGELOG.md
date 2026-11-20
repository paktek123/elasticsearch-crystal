# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Removed

APIs that no longer exist in Elasticsearch 8/9 have been removed:

- `benchmark`, `abort_benchmark`, `list_benchmarks` (never GA). No replacement.
- `count_percolate` (removed in 6.0). No replacement.
- `indices.delete_mapping` (removed in 2.0). No replacement.
- `indices.put_warmer`, `indices.get_warmer`, `indices.delete_warmer` (removed in 5.0). No replacement.
- `indices.optimize` (removed in 5.0). Use `indices.forcemerge`.
- `indices.status` (removed in 2.0). Use `indices.stats` or `indices.recovery`.
- `indices.seal` (removed in 6.0). No replacement.
- `indices.snapshot_index` (removed in 2.0). No replacement.
- `indices.flush_synced` (removed in 8.0). Use `indices.flush`.
- `indices.upgrade` (removed in 8.0). No replacement.
- `indices.exists_type` (removed in 8.0). No replacement.
- `indices.get_aliases` (removed in 6.0). Use `indices.get_alias`.
- `nodes.shutdown` (removed in 2.0; Elasticsearch now has a separate node shutdown API). No replacement.
