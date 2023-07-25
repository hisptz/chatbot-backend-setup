# DHIS2 Analytics Messenger Backend

## Introduction

This is a general setup of the services that are required for
the [DHIS2 Analytics Messenger](https://github.com/hisptz/dhis2-analytics-messenger-app) app.

## Requirements

To set up the services require the following:

- Docker Engine: version `>=23.0.5`
- Docker Compose Plugin version `>=v2.15.1`
- Whatsapp registered phone

Both of these can be installed by instructions provided in
the [Docker documentation](https://docs.docker.com/engine/install/)

## Getting started

### Downloading the project

To set up the services, clone this repository into your server.

### Setting up configuration

Then create an `.env.` file. You can duplicate the `.env.example`

The variables marked * should be changed. Otherwise, the others should be left as in example files unless specified
otherwise

#### Whatsapp service

This is a whatsapp gateway service, allowing receiving and sending of whatsapp messages. The whatsapp service requires
the following variables to be changed:

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
  Where the postgres credentials are the ones defined for the DB service
  You can learn more about the chat-bot service from [here](https://github.com/hisptz/chatbot-server#readme)

#### DHIS2 Mediator service

This a service that connects to a DHIS2 instance and exposes APIs without requiring DHIS2 authentication. Variables
required for this service include:

- `DHIS2_BASE_URL*` - URL to DHIS2 instance
- `DHIS2_USERNAME*` - User to authenticate as (DISCLAIMER: THIS SHOULD BE A USER WITH ONLY REQUIRED ROLES!)
- `DHIS2_PASSWORD*` - Password to authenticate with.
- `DHIS2_API_TOKEN` - PAT token (can be used instead of the password. Takes preference)

#### DHIS2 Visualizer service

This a server that generates an image of a visualization. None of the variables need to be changed:
You can learn more about the visualizer service from [here](https://github.com/hisptz/dhis2-visualizer)

#### Proxy service

This is a service that acts as a gateway for all services. Variables required to change include:

- `PROXY_BASE_URL` - The actual url where your service will be hosted
- `PROXY_API_MOUNT_POINT` - Path of where your service will be hosted
- `PROXY_API_KEY` - An API key for security. It can be a password phrase or a generated random key

### Starting the services

To start all the services, in the project folder run:

```shell
./start-service.sh follow
```

This will pull all the required docker images and start the services. It might take some time for the first time. If it
completes successfully, all the services will be up and running. The `follow` keyword allows you to view the `whatsapp`
service logs. You need to view these initially as there will be a QR code printed. The QR code is used to connect to
your whatsapp.
On the whatsapp phone, go to [linked
devices](https://faq.whatsapp.com/1317564962315842/?cms_platform=web) menu and select to add a new linked device. When
prompted to scan a QR Code, scan the one on the logs. If the
scan is successful, the phone will show a login notification. Your whatsapp service has been successfully set up.

To see if all services are running, run:

```shell
 ./list-services.sh
```

There should be 6 services running, `db`, `whatsapp`, `chat-bot`, `mediator`, `visualizer` and `proxy`

### Connecting to DHIS2 Analytics Messenger App

To connect your backend to the [Analytics Messenger App](https://github.com/hisptz/dhis2-analytics-messenger-app) create
a new gateway in the gateway configuration tab. assign gateway URL to point to exposed proxy port and set the apiKey as
the one set as `PROXY_API_KEY` in the `.env` file.

### Managing the services

To restart all services run:

```shell
./restart-services.sh
```

And to stop all services run:

```shell
./stop-services.sh
```

To view service logs run:

```shell
./view-logs.sh
```







