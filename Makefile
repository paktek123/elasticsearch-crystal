.PHONY: install format build run-test

install:
	shards install

format:
	crystal tool format --check src test

build:
	crystal build --no-codegen src/elasticsearch/api.cr

# Requires Elasticsearch listening on localhost:9250 (see README "Contribute").
run-test:
	crystal spec test/integration/actions
	crystal spec test/integration/cat
	crystal spec test/integration/cluster
	crystal spec test/integration/indices
	crystal spec test/integration/ingest
	crystal spec test/integration/nodes
	crystal spec test/integration/snapshot
	crystal spec test/integration/tasks
