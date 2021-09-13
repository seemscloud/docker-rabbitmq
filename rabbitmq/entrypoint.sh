#!/bin/bash

rabbitmq-plugins enable rabbitmq_management
rabbitmq-server -detach &

while true; do
  timeout 5 bash -c "</dev/tcp/${HOSTNAME}/5672" && break
  echo "Waiting for connection.." && sleep 1
done

sleep 2 && echo "Connected.."

if [[ ${IS_MGMT} == "true" ]]; then
  rabbitmqctl add_user admin admin
  rabbitmqctl set_user_tags admin administrator
  rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
  rabbitmqctl delete_user guest

  rabbitmqctl stop_app
  rabbitmqctl shutdown

  sleep 5

  rabbitmq-server
else
  rabbitmqctl stop_app
  rabbitmqctl reset
  rabbitmqctl join_cluster rabbit@${RABBITMQ_MGMT}
  rabbitmqctl shutdown

  rabbitmq-server
fi
