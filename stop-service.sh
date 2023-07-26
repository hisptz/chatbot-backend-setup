#!/bin/bash
echo "Stopping the Analytics Messenger services..."
docker compose down
rm whatsapp/tokens/whatsapp-session/Singleton*
