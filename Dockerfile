# Use the official PostgreSQL image based on Debian
FROM postgres:15

# Install necessary dependencies and extensions
RUN apt-get update && apt-get install -y \
    postgresql-15-postgis-3 \
    postgresql-15-postgis-3-scripts \
    postgresql-server-dev-15 \
    build-essential \
    wget \
    && wget https://github.com/pgvector/pgvector/archive/refs/tags/v0.7.3.tar.gz \
    && tar -xzvf v0.7.3.tar.gz \
    && cd pgvector-0.7.3 \
    && make CFLAGS="-mtune=generic" && make install \
    && cd .. && rm -rf pgvector-0.7.3 v0.7.3.tar.gz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add a custom initialization script for the extensions
COPY ./initdb-postgis-pgvector.sh /docker-entrypoint-initdb.d/

# Set the default database and user
ENV POSTGRES_DB=mydb
ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword

# Expose the PostgreSQL port
EXPOSE 5432
