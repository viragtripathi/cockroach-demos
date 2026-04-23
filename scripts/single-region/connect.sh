#!/bin/bash

# Helper script to connect to insecure CockroachDB cluster

echo "Connecting to cluster..."
docker exec -it crdb-1 /cockroach/cockroach sql --insecure
