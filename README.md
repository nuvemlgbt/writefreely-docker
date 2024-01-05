# writefreely-docker

This is a [Docker][docker] image for [WriteFreely][writefreely], set up in a way
that makes it easier to deploy it in production, including the initial setup step.

 [docker]: https://www.docker.com/
 [writefreely]: https://github.com/writeas/writefreely

## Getting started

## Setup

The image will perform an initial setup, unless the supplied volume already
contains a `config.ini`. Settings can be tweaked via environment variables, of
which you can find a list below. Do note that these environment variables are
*only* used for the initial setup as of this writing! If a configuration file
already exists, the environment variables will be blissfully ignored.

### Environment variables

- `WRITEFREELY_DB_TYPE` is the db type. Values: mysql or sqlite3
- `WRITEFREELY_DB_USERNAME` is the username of MySQL-compatible database.
- `WRITEFREELY_DB_PASSWORD` is the password of MySQL-compatible database.
- `WRITEFREELY_DB_DATABASE` is the database of MySQL-compatible database.
- `WRITEFREELY_DB_HOST` is the host of MySQL-compatible database.
- `WRITEFREELY_DB_PORT` is the port of MySQL-compatible database.
- `WRITEFREELY_BIND_HOST` and `WRITEFREELY_BIND_PORT` determine the host and port WriteFreely will bind to. Defaults to `0.0.0.0` and `8080`, respectively.
- `WRITEFREELY_SITE_NAME` is the site title one wants. Defaults to "A Writefreely blog".
- `WRITEFREELY_SINGLE_USER`, `WRITEFREELY_OPEN_REGISTRATION`,
  `WRITEFREELY_MIN_USERNAME_LEN`, `WRITEFREELY_MAX_BLOG`,
  `WRITEFREELY_FEDERATION`, `WRITEFREELY_PUBLIC_STATS`, `WRITEFREELY_PRIVATE`,
  `WRITEFREELY_LOCAL_TIMELINE`, and `WRITEFREELY_USER_INVITES` all correspond to
  the similarly named `config.ini` settings. See the [WriteFreely docs][wf:docs]
  for more information about them.

 [wf:docs]: https://writefreely.org/docs/latest/admin/config

 ### Creating a admin user

 1. Enter in the container with the command docker exec -it [container_name] bash
 1. Execute the command '/writefreely/writefreely --create-admin "[username]:[password]"'

## Testing the image (Do not use this for production)

- MariaDB/MySQL: execute-mysql.sh
- SQLite: execute-sqlite.sh

User: test Password: test