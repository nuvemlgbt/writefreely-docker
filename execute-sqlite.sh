#! /bin/sh
docker compose down
rm -rf ./writefreely/config.ini
rm -rf ./writefreely/keys
docker-compose -f docker-compose-sqlite.yaml up -d --build 