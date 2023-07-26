#!/bin/bash

echo "Start up the Analytics messenger services..."
source .env;

WHATSAPP_SINGLETON_FILES="whatsapp"

if [ -d "$WHATSAPP_SINGLETON_FILES" ]; then
  rm whatsapp/tokens/whatsapp-session/Singleton*
fi


docker compose up -d

echo "Services available at http://localhost:$PROXY_PORT"
# Get the first argument and assign it to a variable $SHOULD_FOLLOW_LOGS

SHOULD_FOLLOW_LOGS=$1
if [ "$SHOULD_FOLLOW_LOGS" = "follow" ]; then
  echo "Following logs"
  docker compose logs -f whatsapp
  else
    echo "To follow logs, run the script with the argument follow"
    echo "Example: ./startup-service.sh follow"
fi

