# Build stage
FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    git \
    libtool \
    libzmq3-dev \
    pkg-config \
    yasm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN git clone https://github.com/ShorelineCrypto/ckpool-lhr-chta.git  .

# Optional: disable architecture-specific assembly optimizations if cross-compiling or facing CPU flag issues
# RUN sed -i "s/host_cpu = 'x86_64'/host_cpu = 'x86_64-disabled'/" configure.ac && \
#     sed -i "s/host_cpu = 'aarch64'/host_cpu = 'aarch64-disabled'/" configure.ac

RUN ./autogen.sh && \
    ./configure && \
    make -j"$(nproc)"

# Runtime stage
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libzmq5 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/src/ckpool /usr/local/bin/ckpool
COPY --from=builder /build/src/ckpmsg /usr/local/bin/ckpmsg
COPY --from=builder /build/src/notifier /usr/local/bin/notifier

RUN mkdir -p /etc/ckpool /var/log/ckpool /var/run/ckpool

EXPOSE 3433

ENTRYPOINT ["ckpool"]
CMD ["-B", "-c", "/etc/ckpool/ckpool.conf", "-s", "/var/run/ckpool", "-l", "5"]
