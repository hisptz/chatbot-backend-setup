#!/bin/bash
echo "Stop the Chatboat services..."
docker compose down
rm whatsapp/tokens/whatsapp-session/Singleton*