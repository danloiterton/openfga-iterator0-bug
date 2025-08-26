FROM debian:stable-slim

# Install dependencies: curl, jq, bash
RUN apt-get update && apt-get install -y \
    curl jq bash ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Install OpenFGA CLI
ARG OPENFGA_CLI_VERSION=0.7.4
ARG OPENFGA_TAR=fga_${OPENFGA_CLI_VERSION}_linux_amd64.tar.gz
WORKDIR /tmp
ADD https://github.com/openfga/cli/releases/download/v${OPENFGA_CLI_VERSION}/${OPENFGA_TAR} \
    ./${OPENFGA_TAR}
RUN tar -xzf ${OPENFGA_TAR} \
    && mv fga /usr/local/bin/fga \
    && chmod +x /usr/local/bin/fga \
    && rm ${OPENFGA_TAR}

# Verify installation
RUN fga --version

# Copy model, tuples, and test script
WORKDIR /app
COPY authModel.fga tuples.json run-tests.sh ./
RUN chmod +x /app/run-tests.sh

ENTRYPOINT ["/app/run-tests.sh"]