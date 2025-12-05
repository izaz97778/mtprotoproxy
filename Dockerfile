FROM ubuntu:24.04
# Install Python and dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        python3 \
        python3-uvloop \
        python3-cryptography \
        python3-socks \
        libcap2-bin \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Allow Python to bind to low ports
RUN setcap cap_net_bind_service=+ep $(readlink -f /usr/bin/python3)

# Create a non-root user
RUN useradd tgproxy -u 10000

# Switch to the non-root user
USER tgproxy

# Set working directory
WORKDIR /home/tgproxy/

# Copy proxy files with proper ownership
COPY --chown=tgproxy:tgproxy mtprotoproxy.py config.py /home/tgproxy/

# Run the proxy
CMD ["python3", "mtprotoproxy.py"]
