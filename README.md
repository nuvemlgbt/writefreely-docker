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
- `WRITEFREELY_ADMIN_USER` and `WRITEFREELY_ADMIN_PASSWORD` will be used to automatically create an admin user, if they're specified. If either is missing, and admin user will not be created.

 [wf:docs]: https://writefreely.org/docs/latest/admin/config

### Build arguments

- `WRITEFREELY_UID` sets the default user (and group) id of the `writefreely` user created during build. Defaults to `5000`, only used during the build.
- `WRITEFREELY_VERSION` controls which version of Writefreel the image is build from. Defaults to `v0.14.0`, can be any tag or branch.
- `WRITEFREELY_FORK` sets which fork - if any - to use. Defaults to `writefreely/writefreely`, and must be a GitHub repository at the moment.
- `WRITEFREELY_REF` - if set - sets the reference to check out after cloning. The goal is to augment `WRITEFREELY_VERSION`, if we want to clone writefreely at a non-tagged, non-branch version. Defaults to `62f9b2948ecaf6e8b4362570bf0e55111a24a183` for now, because this commit is needed on top of the 0.14.0 release. Change it to an empty string if switching away from `0.14.0`.
