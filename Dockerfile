FROM ubuntu:20.04

# Install dependencies
RUN apt-get update \
    && apt-get install -y \
        gnupg \
        wget \
        apt-transport-https \
        openjdk-11-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Elasticsearch version and URLs
ENV ES_VERSION=8.14.2
ENV ES_DEB_URL=https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-amd64.deb
ENV ES_SHA_URL=https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-amd64.deb.sha512

# Install Elasticsearch GPG key and repository
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - \
    && echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-8.x.list

# Update package index and install Elasticsearch
RUN apt-get update \
    && apt-get install -y elasticsearch=${ES_VERSION} \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create directories and set permissions
RUN mkdir -p /usr/share/elasticsearch/data /usr/share/elasticsearch/logs /usr/share/elasticsearch/config/scripts \
    && chown -R elasticsearch:elasticsearch /usr/share/elasticsearch

# Copy configuration files
COPY elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
COPY logging.yml /usr/share/elasticsearch/config/logging.yml

# Expose ports
EXPOSE 9200 9300

# Change ownership of Elasticsearch data directory
RUN chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data

# Switch to the elasticsearch user
USER elasticsearch

# Command to run Elasticsearch
CMD ["/usr/share/elasticsearch/bin/elasticsearch"]

