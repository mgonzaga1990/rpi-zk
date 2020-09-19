#!/bin/bash

set -e

echo 'Starting up'

echo 'Creating folder for data'
mkdir -p /var/lib/zookeeper

# Generate the config only if it doesn't exist
if [ ! -f "$ZOO_CONF/zoo.cfg" ]; then
    CONFIG="$ZOO_CONF/zoo.cfg"

    echo "clientPort=$ZOO_PORT" >> "$CONFIG"
    echo "dataDir=$ZOO_DATA_DIR" >> "$CONFIG"

    echo "tickTime=$ZOO_TICK_TIME" >> "$CONFIG"
    echo "initLimit=$ZOO_INIT_LIMIT" >> "$CONFIG"
    echo "syncLimit=$ZOO_SYNC_LIMIT" >> "$CONFIG"

    x=$ZOO_SERVERS
    while [ $x -gt -1 ];
    do
      index=$(($x + 1))
      echo "server.$index=zk-$x.zk-hs.default.svc.cluster.local:2888:3888" >> "$CONFIG"
      x=$(($x-1))
    done

    cat $CONFIG
fi

# Write myid only if it doesn't exist
if [ ! -f "$ZOO_DATA_DIR/myid" ]; then
    echo 'creating id'
    id="${HOSTNAME//[!0-9]/}"
    nid=$(($id+1))
    echo "${nid}" > "$ZOO_DATA_DIR/myid"
    cat $ZOO_DATA_DIR/myid
fi

./${ZOO}/bin/zkServer.sh start-foreground
