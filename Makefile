install:
	shards install
run-test:
	crystal spec test/integration/actions/*
	crystal spec test/integration/cat/*
	crystal spec test/integration/cluster/*
	crystal spec test/integration/indices/*
	crystal spec test/integration/ingest/*
	crystal spec test/integration/nodes/*
	crystal spec test/integration/snapshot/*
	crystal spec test/integration/tasks/*
