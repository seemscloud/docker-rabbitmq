#!/bin/bash

rabbitmq-plugins enable rabbitmq_management

if [[ ${IS_MGMT} == "true" ]]; then
  true
else
  true
fi

rabbitmq-server
