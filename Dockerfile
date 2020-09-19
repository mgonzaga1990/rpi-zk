FROM openjdk:16-slim

# Install required packages
RUN apt-get update && apt-get install -y wget iputils-ping dnsutils

# Default number of servers
ENV ZOO_SERVERS=2

# Create user
ENV ZOO_USER=zookeeper

# Folder directories
ENV ZOO=/opt/zookeeper \
	ZOO_CONF=/opt/zookeeper/conf \
	ZOO_DATA_DIR=/var/lib/zookeeper \
	ZOO_DATA_LOG_DIR=/opt/zookeeper/log

# Default cfg values
ENV	ZOO_TICK_TIME=2000 \
	ZOO_INIT_LIMIT=5 \
	ZOO_SYNC_LIMIT=2

ENV ZOO_PORT=2181

# Download zookeeper
RUN wget -c https://downloads.apache.org/zookeeper/zookeeper-3.6.2/apache-zookeeper-3.6.2-bin.tar.gz

# Untar and move to /opt folder
RUN tar -xzf apache-zookeeper-3.6.2-bin.tar.gz -C /opt/ \
		&& rm -r apache-zookeeper-3.6.2-bin.tar.gz
RUN mv /opt/apache-zookeeper-* /opt/zookeeper

EXPOSE $ZOO_PORT 2888 3888

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

VOLUME ["$ZOO_DATA_DIR", "$ZOO_DATA_LOG_DIR"]
	
ENTRYPOINT /entrypoint.sh

#CMD ["/opt/zookeeper/bin/zkServer.sh", "start-foreground"]



