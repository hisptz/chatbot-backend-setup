## Setting up Analytics Messenger within a DHIS2 server managed by LXC script

If you intend to host the analytics messenger service alongside your DHIS2 installation and have used the
famous [Bob's script](https://github.com/bobjolliffe/dhis2-tools-ng) to set up your instance, here is a simple guide
that might simplify and help to avoid some issues.

### Setting up the LXC container

In order to set up the services so they interact well with the existing containers, we recommend you create a new LXC
container that will hold the services.
You can use the command `dhis2-create-instance` to set up a blank instance.

```shell
 sudo dhis2-create-instance <messenger-container> <ip-address> <postgres-container-name>
```

Where `messenger` is the name of the container, `IP` is the ip of the container, and `postgres` is the name of the
database container.

After the container is created. You need to container nesting for the container. To do this run

```shell
sudo lxc config set <messenger-container> security.nesting true
```

Where messenger is the name of the container.

### Configuring DHIS2 container

Since your DHIS2 instance is hosted in the same server. You can connect it through lxc network instead of specifying a
FQDN. In order to do this, the created container should have access to the DHIS2 container.

First get into the DHIS2 container

```shell
    sudo lxc exec <dhis2-container-name> bash
```

Then update the firewall configuration by allowing access from the messenger container

```shell
    ufw allow proto tcp from <messenger-container-ip-address> to any port 8080
```

Then you can exit the container.

```shell
 exit 
```

### Configuring the messenger container

Finally, get into the messenger container,

```shell
    sudo lxc exec <messenger-container> bash 
```

Since tomcat is not needed for the services, you can stop it and disable it from running on startup

```shell
 systemctl stop tomcat9
```

```shell
 systemctl disable tomcat9
```

You can then get the database password by previewing the `dhis2.conf`. This will be required when setting up the
database URL in configuration

```shell

cat /opt/dhis2/dhis.conf | grep "connection.password=*"

// connection.password = 6528211e6f6a517bf14856a3fddf3c2c35944eb61

```

Then set up the requirements as explained in the [docs](README.md#installation) and set up the analytics messenger as
explained in the [docs](README.md#backend-server-setup)

When setting up the configuration, Then following changes should be done.

set the `DHIS2_BASE_URL` to point to the dhis2 container. e.g `DHIS2_BASE_URL=http://192.168.0.21:8080`

set the `PROXY_API_MOUNT_POINT` to the name of the messenger container starting with a forward slash.
e.g `PROXY_API_MOUNT_POINT=/<messenger-container>`

set the `ENGINE_DATABASE_URL` to point to the database created in the postgres container. Default credentials for the
database are `<messenger-container>:<connection-password>`. So the URL will look
like `postgres://<messenger-container>:<connection-password>@<postgres-container-ip>:5432/<messenger-container>`.
The `connection-password` is the password obtained from the `dhis2.conf` file

set the `PROXY_PORT` variable to `8080`.

By default, the analytics messenger comes with its own database container. To disable this container from starting, edit
the `docker-compsose.yml` file

```shell
 nano docker-compose.yml
```

Then uncomment the lines under the db service by removing the has at the beginning of the line

```yaml

db:
  image: postgres:latest
  volumes:
    - ./data:/var/lib/postgresql/data
  env_file:
    - .env
#    profiles: uncomment this line
#      - donotstart uncomment this line

```

You can start the services as explained in the [docs](README.md#starting-the-backend-services)





