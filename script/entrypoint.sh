#!/bin/sh

echo "Starting node at ${HOSTNAME} with cluster at ${CLUSTER_SEED}"

docker-entrypoint.sh rabbitmq-server -detached

# Set result before starting 
res=1

# Check result of diagnostics be success
until [ $res -eq 0 ] 
  do 
    echo "Checking if node has started at ${HOSTNAME}"
    rabbitmq-diagnostics -q check_running > /dev/null 2>&1
    res=$?
    sleep 3
  done


echo "Node has started at ${HOSTNAME}, Joining cluster ${CLUSTER_SEED}"

rabbitmqctl --quiet stop_app
rabbitmqctl --quiet reset 
rabbitmqctl --quiet join_cluster ${CLUSTER_SEED}
rabbitmqctl --quiet stop

echo "Starting server again"
docker-entrypoint.sh rabbitmq-server
