#! /bin/sh
## Writefreely wrapper for Docker
## Copyright (C) 2024 Nuvem LGBT
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU Gener`al`` Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -e

cd /data

WRITEFREELY=/writefreely/writefreely

if [ -e ./config.ini ]; then
    if [ "$WRITEFREELY_IGNORE_DB_INIT" = "true" ]; then
        echo "WRITEFREELY_IGNORE_DB_INIT is set. Ignoring db init."
    else
        ${WRITEFREELY} db init
    fi

    if [ ! -e ./keys/email.aes256 ]; then
        ${WRITEFREELY} keys generate
    fi

    ${WRITEFREELY} db migrate
    
    exec ${WRITEFREELY}

fi

WRITEFREELY_BIND_PORT="${WRITEFREELY_BIND_PORT:-8080}"
WRITEFREELY_BIND_HOST="${WRITEFREELY_BIND_HOST:-0.0.0.0}"
WRITEFREELY_SITE_NAME="${WRITEFREELY_SITE_NAME:-A Writefreely blog}"


cat >./config.ini <<EOF
[server]
hidden_host          =
port                 = ${WRITEFREELY_BIND_PORT}
bind                 = ${WRITEFREELY_BIND_HOST}
tls_cert_path        =
tls_key_path         =
templates_parent_dir = /writefreely
static_parent_dir    = /writefreely
pages_parent_dir     = /writefreely
keys_parent_dir      =

[database]
type     = mysql
filename = 
username = ${WRITEFREELY_DB_USERNAME}
password = ${WRITEFREELY_DB_PASSWORD}
database = ${WRITEFREELY_DB_DATABASE}
host     = ${WRITEFREELY_DB_HOST}
port     = ${WRITEFREELY_DB_PORT}

[app]
site_name         = ${WRITEFREELY_SITE_NAME}
site_description  =
host              = ${WRITEFREELY_HOST:-http://${WRITEFREELY_BIND_HOST}:${WRITEFREELY_BIND_PORT}}
theme             = write
disable_js        = false
webfonts          = true
landing           =
single_user       = ${WRITEFREELY_SINGLE_USER:-false}
open_registration = ${WRITEFREELY_OPEN_REGISTRATION:-false}
min_username_len  = ${WRITEFREELY_MIN_USERNAME_LEN:-3}
max_blogs         = ${WRITEFREELY_MAX_BLOG:-1}
federation        = ${WRITEFREELY_FEDERATION:-true}
public_stats      = ${WRITEFREELY_PUBLIC_STATS:-false}
private           = ${WRITEFREELY_PRIVATE:-false}
local_timeline    = ${WRITEFREELY_LOCAL_TIMELINE:-false}
user_invites      = ${WRITEFREELY_USER_INVITES}
EOF

if [ "$WRITEFREELY_IGNORE_DB_INIT" = "true" ]; then
    echo "WRITEFREELY_IGNORE_DB_INIT is set. Ignoring db init."
else
    ${WRITEFREELY} db init
fi

${WRITEFREELY} keys generate

exec ${WRITEFREELY}
