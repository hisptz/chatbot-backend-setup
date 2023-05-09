# DHIS2 Analytics Messenger Backend

## Introduction

This is a general setup of the services that are required for
the [DHIS2 Analytics Messenger](https://github.com/hisptz/dhis2-analytics-messenger-app) app.

## Requirements

To set up the services require the following:

- Docker Engine: version `>23.0.5`
- Docker Compose Plugin version `>v2.15.1`
- Whatsapp registered phone

Both of these can be installed by instructions provided in
the [Docker documentation](https://docs.docker.com/engine/install/)

## Getting started

### Downloading the project

To set up the services, clone this repository into your server.

### Setting up configuration

Then create an `.env.(service)` file with the required
variables for each service. An example of each `.env` file required has been provided.

The variables marked * should be changed. Otherwise, the others should be left as in example files unless specified otherwise

#### Whatsapp service

This is a whatsapp gateway service, allowing receiving and sending of whatsapp messages. The whatsapp service requires
the following variables:

- `WHATSAPP_MESSAGE_HANDLER_GATEWAY`- A server that handles whatsapp incoming messages (in this case it is the chat-bot
  server)
- `ALLOWED_CONTACTS*` - A list of whitelisted phone numbers. The whatsapp service will only read incoming messages from
  these numbers. Leave this empty if you want to reply to all phone numbers

You can learn more about the whatsapp service from [here](https://github.com/hisptz/whatsapp-server#readme)

#### Postgres DB service

This is an internal service required by the `chat-bot` service. It requires the following variables:

- `POSTGRES_PASSWORD*` - Database password
- `POSTGRES_USER*` - Database user

#### Chat-bot service

This is a simple server that uses decision tree based algorithm to perform different actions based on the user
selection.
The chat-bot service requires:

- `DATABASE_URL*` - URL to the database (db service) in the
  format `postgres://<POSTGRES_USER>:<POSTGRES_PASSWORD>@server_name:port/chatbot`
- `API_MOUNT_POINT*` - A path from which the chat-bot service will be accessible. Example if set to `/api` then the
  service will be available at `http://localhost:3000/api`

You can learn more about the chat-bot service from [here](https://github.com/hisptz/chatbot-server#readme)

#### DHIS2 Mediator service

This a service that connects to a DHIS2 instance and exposes APIs without requiring DHIS2 authentication. Variables
required for this service include:

- `DHIS2_BASE_URL*` - URL to DHIS2 instance
- `DHIS2_USERNAME*` - User to authenticate as (DISCLAIMER: THIS SHOULD BE A USER WITH ONLY REQUIRED ROLES!)
- `DHIS2_PASSWORD*` - Password to authenticate with.
- `ALLOWED_RESOURCES` - A list of resources that the API exposes.
- `READONLY_RESOURCES` - A list of resources that the API treats as read-only (Will not allow to update/create the
  resource)

#### DHIS2 Visualizer service

This a server that generates an image of a visualization. Variables required are:

- `API_MOUNT_POINT*` - A path from which the chat-bot service will be accessible. Example if set to `/api` then the
  service will be available at `http://localhost:3000/api`
- `DHIS2_MEDIATOR_URL` - URL to the DHIS2 mediator service

You can learn more about the visualizer service from [here](https://github.com/hisptz/dhis2-visualizer)

### Starting the services

To start all the services navigate to the project folder:

```shell
 cd chatbot-backend-setup
```

and then run:

```shell
 docker compose up -d 
```

This will pull all the required docker images and start the services. It might take some time for the first time. If it
completes successfully, all the services will be up and running. To see if all services are running, run:

```shell
 docker compose ps
```

There should be 5 services running, `db`, `whatsapp`, `chat-bot`, `mediator`, and `visualizer`

### Setting up the Whatsapp service

After starting all the services, you need to link your whatsapp account with the whatsapp service. This has to be done
immediately after running `docker compose up -d` command (The container will exit after about 3 minutes if the whatsapp
account is not linked).

To set up the account run the command:

```shell
 docker compose logs -f whatsapp
```

To view the whatsapp service logs. There will be a QR code printed on the logs. On the whatsapp phone, go to [linked
devices](https://faq.whatsapp.com/1317564962315842/?cms_platform=web) menu and select to add a new linked device. When
prompted to scan a QR Code, scan the one on the logs. If the
scan is successful, the phone will show a login notification. Your whatsapp service has been successfully set up.

### Setting up a reverse proxy

The `whatsapp`, `chat-bot`, and `visualizer` services need to be accessible outside the server. These are accessible on
ports `4000`, `3000`, and `7000` respectfully. A `nginx.conf` example file of how to set up the reverse proxy has been
provided.

### Connecting to DHIS2 Analytics Messenger App

To connect your backend to the [Analytics Messenger App](https://github.com/hisptz/dhis2-analytics-messenger-app) create
a new gateway in the gateway configuration tab. assign gateway URL to point to the exposed whatsapp endpoint of your
backend.






