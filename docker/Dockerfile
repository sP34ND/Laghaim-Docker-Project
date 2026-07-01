# Laghaim game server — 32-bit Linux binaries (Connector, LhDebug, etc.)
FROM i386/debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    gdb \
    netcat-traditional \
    socat \
    iproute2 \
    procps \
    ca-certificates \
    libstdc++6 \
    libgcc-s1 \
    libgmp10 \
    zlib1g \
    libgnutls30 \
    libiconv-hook1 \
    wget \
    binutils \
    dpkg \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

COPY docker/install-mysql-client.sh /tmp/install-mysql-client.sh
RUN sed -i 's/\r$//' /tmp/install-mysql-client.sh && \
    chmod +x /tmp/install-mysql-client.sh && \
    bash /tmp/install-mysql-client.sh && \
    rm -f /tmp/install-mysql-client.sh

# Legacy .so names expected by the game binaries
RUN set -eux; \
    cd /usr/lib/i386-linux-gnu; \
    ln -sf libgmp.so.10 libgmp.so.3; \
    if [ -f libexpat.so.1 ]; then ln -sf libexpat.so.1 libexpat.so.0; fi; \
    ldconfig

# The game binaries need GNU libiconv symbols (libiconv_open / libiconv / libiconv_close).
# libiconv_hook does NOT export these, so symlinking libiconv.so.2 -> libiconv_hook is wrong
# and makes the Connector die with "undefined symbol: libiconv_open" on the first login
# (a2u() cp949->utf-8 conversion). Ship a thin libiconv.so.2 shim over glibc iconv instead.
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends gcc libc6-dev; \
    printf '%s\n' \
      '#include <iconv.h>' \
      '#include <stddef.h>' \
      'iconv_t libiconv_open(const char *t, const char *f){ return iconv_open(t, f); }' \
      'size_t libiconv(iconv_t cd, char **i, size_t *il, char **o, size_t *ol){ return iconv(cd, i, il, o, ol); }' \
      'int libiconv_close(iconv_t cd){ return iconv_close(cd); }' \
      > /tmp/libiconv_shim.c; \
    rm -f /usr/lib/i386-linux-gnu/libiconv.so.2; \
    gcc -shared -fPIC -Wl,-soname,libiconv.so.2 \
        -o /usr/lib/i386-linux-gnu/libiconv.so.2 /tmp/libiconv_shim.c; \
    rm -f /tmp/libiconv_shim.c; \
    rm -rf /var/lib/apt/lists/*; \
    ldconfig; \
    readelf --dyn-syms /usr/lib/i386-linux-gnu/libiconv.so.2 | grep -q libiconv_open

WORKDIR /opt/laghaim

COPY svlaghaim/ .

RUN chmod -R 755 /opt/laghaim && \
    find /opt/laghaim -name "*.sh" -exec sed -i 's/\r$//' {} +

# Fail the image build if the game binaries cannot resolve libmysqlclient_16
RUN ldd /opt/laghaim/bin/Connector 2>&1 | tee /tmp/ldd-connector.txt && \
    grep -q 'libmysqlclient.so.16' /tmp/ldd-connector.txt && \
    ! grep -q 'not found' /tmp/ldd-connector.txt

COPY docker/entrypoint.sh /entrypoint.sh
COPY docker/apply-exp-rate.sh /apply-exp-rate.sh
COPY docker/apply-drop-rate.sh /apply-drop-rate.sh
COPY docker/apply-gem-shop-laglamia.sh /apply-gem-shop-laglamia.sh
COPY docker/apply-phewphew-max-money.sh /apply-phewphew-max-money.sh
COPY docker/start-minimal.sh /opt/laghaim/start-minimal.sh

RUN sed -i 's/\r$//' /entrypoint.sh /apply-exp-rate.sh /apply-drop-rate.sh /apply-gem-shop-laglamia.sh /apply-phewphew-max-money.sh /opt/laghaim/start-minimal.sh && \
    chmod +x /entrypoint.sh /apply-exp-rate.sh /apply-drop-rate.sh /apply-gem-shop-laglamia.sh /apply-phewphew-max-money.sh /opt/laghaim/start-minimal.sh

EXPOSE 4011 4012 4015 4018 4021
EXPOSE 4001-4036 5001-5036

ENTRYPOINT ["/entrypoint.sh"]
