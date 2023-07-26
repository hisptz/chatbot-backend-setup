#!/bin/bash
echo "Starting the Analytics Messenger services..."
rm whatsapp/tokens/whatsapp-session/Singleton*
docker compose up -d --pull always
