FROM cockroachdb/cockroach:latest AS base

LABEL maintainer="virag.tripathi@gmail.com"
LABEL version="1.0"
LABEL description="cockroach base image"
LABEL REFRESHED_AT =(date)

FROM ubuntu

# iproute2 - required to simulate the latency between the cluster nodes.

RUN apt-get update && apt-get install -y \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /usr/local/lib/cockroach /cockroach /licenses /docker-entrypoint-initdb.d
COPY --from=base  /cockroach/* /cockroach/
COPY --from=base  /licenses/* /licenses/
COPY --from=base /usr/local/lib/cockroach/* /usr/local/lib/cockroach/

# Set working directory so that relative paths
# are resolved appropriately when passed as args.
WORKDIR /cockroach/

# Include the directory in the path to make it easier to invoke
# commands via Docker
ENV PATH=/cockroach:$PATH

ENV COCKROACH_CHANNEL=unofficial-docker

EXPOSE 26257 8080
ENTRYPOINT ["/cockroach/cockroach.sh"]
