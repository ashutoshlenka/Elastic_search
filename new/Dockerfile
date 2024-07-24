# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Install necessary packages (OpenJDK 11 and wget)
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk wget && \
    rm -rf /var/lib/apt/lists/*

# Create a dedicated user and group for Elasticsearch
RUN groupadd -g 1000 elasticsearch && \
    useradd -u 1000 -g 1000 -d /usr/share/elasticsearch -s /bin/bash elasticsearch

# Elasticsearch version and download URLs
ENV ES_VERSION=8.14.2
ENV ES_DEB_URL=https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-amd64.deb
ENV ES_SHA_URL=https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-amd64.deb.sha512

# Download Elasticsearch package and its SHA
RUN wget ${ES_DEB_URL} && \
    wget ${ES_SHA_URL} && \
    sha512sum -c elasticsearch-${ES_VERSION}-amd64.deb.sha512

# Install Elasticsearch
RUN dpkg -i elasticsearch-${ES_VERSION}-amd64.deb

# Elasticsearch configuration
COPY elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
COPY logging.yml /usr/share/elasticsearch/config/logging.yml

# Elasticsearch data directory (can be mounted as a volume)
VOLUME /var/lib/elasticsearch

# Expose ports for Elasticsearch (HTTP and transport)
EXPOSE 9200 9300

# Change ownership of Elasticsearch data directory to elasticsearch user
RUN chown -R elasticsearch:elasticsearch /var/lib/elasticsearch

# Start Elasticsearch in the background
USER elasticsearch
CMD /usr/share/elasticsearch/bin/elasticsearch
