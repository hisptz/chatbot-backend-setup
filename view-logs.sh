#!/bin/bash

SERVICE=$1;
if [ -z "$SERVICE" ]; then
    echo "Service name is required";
    exit 1;
fi;

echo "Viewing logs for service: $SERVICE"

docker compose logs "$SERVICE" -f
