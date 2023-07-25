#!/bin/bash
echo "List all the Chatboat services..."
docker compose down
rm whatsapp/tokens/whatsapp-session/Singleton*