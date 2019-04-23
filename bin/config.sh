#!/usr/bin/env bash

set -eu;

WP_CLI=$(cd $(dirname $0);cd ../;pwd)/vendor/bin/wp
YQ=yq

## Get config.
ROOT=$(cd $(dirname $0);cd ../;pwd)
CONFIG_PATH=$ROOT/.env.json

PUBLIC_DIR="/public_html"
WP_DIR="/wp"
WP_CONTENT_DIR="/wp-content"

DOC_ROOT=$ROOT$PUBLIC_DIR
WP_PATH=$DOC_ROOT$WP_DIR
echo $WP_PATH
if [ -f "$CONFIG_PATH" ]; then
    DB_USER=$($YQ r $CONFIG_PATH "mysql.username")
    DB_PASS=$($YQ r $CONFIG_PATH  "mysql.password")
    DB_NAME=$($YQ r $CONFIG_PATH  "mysql.database")
    DB_HOST=$($YQ r $CONFIG_PATH  "mysql.host")

    URL=$($YQ r $CONFIG_PATH  "server.url")


    WP_TITLE=$($YQ r $CONFIG_PATH  "wp.title")
    WP_DESCRIPTION=$($YQ r $CONFIG_PATH  "wp.description")
    WP_LANG=$($YQ r $CONFIG_PATH  "wp.lang")
    WP_GMT_OFFSET=$($YQ r $CONFIG_PATH  "wp.gmt_offset")
    WP_REWRITE_STRUCTURE=$($YQ r $CONFIG_PATH "wp.rewrute_structure")

    WP_ADMIN_USER=$($YQ r $CONFIG_PATH  "wp.admin.user")
    WP_ADMIN_PASSWORD=$($YQ r $CONFIG_PATH  "wp.admin.password")
    WP_ADMIN_EMAIL=$($YQ r $CONFIG_PATH  "wp.admin.email")

    WP_THEME=$($YQ r $CONFIG_PATH  "wp.theme")

    THEME_UNIT_TEST_URI=$($YQ r $CONFIG_PATH  "theme_unit_test_uri")

else
    echo ".env.json is NOT a file."
    exit 0
fi
