#!/bin/bash

set -e

echo "Starting CockroachDB Insecure Single-Region Cluster"
echo "===================================================="
echo ""

# Show version being used
CRDB_VERSION="${CRDB_VERSION:-v25.4.10}"
echo "CockroachDB version: ${CRDB_VERSION}"
echo ""

# Stop any existing deployment
echo "Stopping existing containers..."
docker compose down -v 2>/dev/null || true

# Start the stack
echo ""
echo "Starting services..."
CRDB_VERSION="${CRDB_VERSION}" docker compose up -d --build

echo ""
echo "Waiting for cluster initialization (10 seconds)..."
sleep 10

echo ""
echo "Cluster Ready!"
echo ""
echo "   CockroachDB Admin Consoles:"
echo "     - http://localhost:8080  (region: us-east-1, zone: a)"
echo "     - http://localhost:8081  (region: us-east-1, zone: b)"
echo "     - http://localhost:8082  (region: us-east-1, zone: c)"
echo ""
echo "   HAProxy stats: http://localhost:8404/stats"
echo ""
echo "   Connect:"
echo "     cockroach sql --insecure --host=localhost:26257"
echo "     or: ./connect.sh"
echo ""
echo "   Via Docker:"
echo "     docker exec -it crdb-1 /cockroach/cockroach sql --insecure"
echo ""
echo "To stop: docker compose down -v"
echo ""
