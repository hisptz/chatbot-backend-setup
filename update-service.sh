#!/bin/bash
echo "Start up the Chatboat services..."
rm whatsapp/tokens/whatsapp-session/Singleton*
docker compose up -d
docker compose logs -f whatsapp
