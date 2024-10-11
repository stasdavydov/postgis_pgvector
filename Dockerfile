# Use the official PostGIS image based on Debian
FROM postgis/postgis:16-3.4

# Install necessary dependencies and extensions
RUN echo "deb [trusted=yes] http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-15 main" | tee /etc/apt/sources.list.d/llvm.list && \
    apt-get update && \
    apt-get install -y clang-15 make wget gcc postgresql-server-dev-16 build-essential && \
    ln -s /usr/bin/clang-15 /usr/bin/clang && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://github.com/pgvector/pgvector/archive/refs/tags/v0.7.4.tar.gz \
    && tar -xzvf v0.7.4.tar.gz \
    && cd pgvector-0.7.4 \
    && make CFLAGS="-mtune=generic" && make install \
    && cd .. && rm -rf pgvector-0.7.4 v0.7.4.tar.gz \
    && apt-get remove -y --purge clang-15 make wget gcc build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add a custom initialization script for the extensions
COPY ./initdb-postgis-pgvector.sh /docker-entrypoint-initdb.d/

# Set the default database and user
ENV POSTGRES_DB=test
ENV POSTGRES_USER=test
ENV POSTGRES_PASSWORD=test

# Expose the PostgreSQL port
EXPOSE 5432
