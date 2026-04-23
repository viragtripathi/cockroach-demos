# CockroachDB Insecure Single-Region Cluster

A 3-node insecure CockroachDB cluster with HAProxy load balancing, deployed in a single region using Docker Compose.

## Quick Download (Without Cloning Entire Repo)

```bash
wget -c https://github.com/viragtripathi/cockroach-collections/archive/main.zip && \
mkdir -p cockroach-single-region && \
unzip main.zip "cockroach-collections-main/scripts/single-region/*" -d cockroach-single-region && \
cp -R cockroach-single-region/cockroach-collections-main/scripts/single-region/* cockroach-single-region/ && \
rm -rf main.zip cockroach-single-region/cockroach-collections-main && \
cd cockroach-single-region && \
chmod +x *.sh
```

## Why This Exists

Demonstrates a simple single-region CockroachDB deployment for **development and testing only**:

- **No TLS/certificates required** - quick setup
- **Single-region topology** (1 region, 3 nodes)
- **HAProxy load balancer** with health checks
- **Automated setup** with Docker Compose

**WARNING: This is INSECURE. Use only for development/testing. For production, use the [multi-region-secure](../multi-region-secure) setup.**

## Prerequisites

### Docker or Podman

You need either:

- **Docker Desktop** (Linux/Mac/Windows), or
- **Podman Desktop** with `podman-compose`

#### If using Podman

Create symlinks so scripts can use `docker` commands:

```bash
sudo ln -s $(which podman) /usr/local/bin/docker
sudo ln -s $(which podman-compose) /usr/local/bin/docker-compose
```

### Docker Permissions Issue (Linux)

If you get permission errors, add your user to the docker group:

```bash
# Add your user to the docker group
sudo usermod -aG docker "$USER"

# Refresh group membership
newgrp docker

# Verify access
docker info
```

### Resource Requirements

Please have at least **4 vCPU**, **10GB RAM** and **20GB storage** for the single-region setup to function properly. Adjust the resources based on your requirements.

## Quick Start

```bash
# Make scripts executable
chmod +x run-insecure.sh connect.sh

# Start the cluster (uses latest version by default)
./run-insecure.sh

# Or specify a CockroachDB version
CRDB_VERSION=v24.3.5 ./run-insecure.sh

# Wait ~10 seconds, then connect
./connect.sh
```

The startup script will:
1. Start 3 CockroachDB nodes in insecure mode
2. Initialize the cluster
3. Configure HAProxy for load balancing
4. Bootstrap the cluster

## Cluster Topology

| Node    | Region    | Zone | Admin UI                    | SQL Port |
|---------|-----------|------|-----------------------------|----------|
| crdb-1  | us-east-1 | a    | http://localhost:8080       | 26257    |
| crdb-2  | us-east-1 | b    | http://localhost:8081       | 26257    |
| crdb-3  | us-east-1 | c    | http://localhost:8082       | 26257    |
| haproxy | -         | -    | http://localhost:8404/stats | 26257    |

## Connecting to the Cluster

### Quick Connect (Easiest)

```bash
# Use the helper script
./connect.sh

# Or connect directly to a node
docker exec -it crdb-1 /cockroach/cockroach sql --insecure
```

### Via HAProxy (Recommended for Load Balancing)

```bash
# Using cockroach CLI
cockroach sql --insecure --host=localhost:26257

# Connection string for applications
postgresql://root@localhost:26257/defaultdb?sslmode=disable
```

### Direct to Node

```bash
# Connect to any specific node
docker exec -it crdb-1 /cockroach/cockroach sql --insecure
docker exec -it crdb-2 /cockroach/cockroach sql --insecure
docker exec -it crdb-3 /cockroach/cockroach sql --insecure
```

## Admin Console Access

Open any of these URLs in your browser:
- http://localhost:8080 (region: us-east-1, zone: a)
- http://localhost:8081 (region: us-east-1, zone: b)
- http://localhost:8082 (region: us-east-1, zone: c)

**No login required** - insecure mode has no authentication.

## Application Examples

### Python

```python
import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port=26257,
    user="root",
    database="defaultdb",
    sslmode="disable"
)

cursor = conn.cursor()
cursor.execute("SELECT version()")
print(cursor.fetchone())
conn.close()
```

### Connection String

```bash
postgresql://root@localhost:26257/defaultdb?sslmode=disable
```

## HAProxy Configuration

The HAProxy config includes:

- **TCP passthrough** for connections
- **TCP health checks** on port 26257
- **Round-robin load balancing** across all 3 nodes
- **Stats UI** at http://localhost:8404/stats

### Monitoring Node Health

Visit HAProxy stats: http://localhost:8404/stats

- Green = healthy node
- Red = node down or unhealthy

## Stopping the Cluster

```bash
# Stop and remove containers
docker compose down

# Stop and remove everything including volumes
docker compose down -v
```

## Common Issues

### "Connection refused"

Ensure the cluster is running:
```bash
docker ps
docker logs crdb-1
```

### HAProxy shows all nodes as DOWN

Check that nodes are running:
```bash
docker ps
docker logs haproxy
```

Restart if needed:
```bash
docker compose restart haproxy
```

## Scaling Up

For multi-region deployments, see:
- [Multi-Region Insecure](../multi-region) - 5 nodes across 3 regions
- [Multi-Region Secure](../multi-region-secure) - production-ready with TLS

## More Information

- [CockroachDB Documentation](https://www.cockroachlabs.com/docs/stable)
- [HAProxy Documentation](https://docs.haproxy.org/)
