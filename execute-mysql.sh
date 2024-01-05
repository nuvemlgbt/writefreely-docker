#! /bin/sh
docker compose down
rm -rf ./writefreely/config.ini
rm -rf ./writefreely/keys
docker compose up -d --build