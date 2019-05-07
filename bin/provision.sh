#!/usr/bin/env bash

set -eu;

SH_DIR=$(cd $(dirname $0);pwd)


. $SH_DIR/config.sh
. $SH_DIR/check-mysql.sh


 if [ ! -e "${DOC_ROOT}${WP_DIR}/wp-config.php" ];then

    cp ${ROOT}/salt.php ${DOC_ROOT}${WP_DIR}/salt.php

    $WP_CLI core config --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASS} --dbhost=${DB_HOST} --skip-salts  --extra-php <<PHP
require_once dirname( __FILE__ ) . '/salt.php';
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );

define( 'WP_SITEURL', '${URL}${WP_DIR}' );
define( 'WP_HOME', '${URL}' );

define( 'WP_CONTENT_DIR', dirname(__DIR__) . '${WP_CONTENT_DIR}' );
define( 'WP_CONTENT_URL', WP_HOME . '${WP_CONTENT_DIR}');


PHP

fi

## Start Server if installed.
if ! $($WP_CLI core is-installed); then

    ## Recreate DB for WordPress.
    if [ $DB_PASS ]; then
        echo "DROP DATABASE IF EXISTS $DB_NAME;" | mysql -u$DB_USER -p$DB_PASS
        echo "CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | mysql -u$DB_USER -p$DB_PASS
    else
        echo "DROP DATABASE IF EXISTS $DB_NAME;" | mysql -u$DB_USER
        echo "CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | mysql -u$DB_USER
    fi


        ## Install WordPress.
        $WP_CLI core install \
        --url=http://"$URL" \
        --path="${DOC_ROOT}${WP_DIR}" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"


    # Setup Options.
    $WP_CLI option update blogname "$WP_TITLE"

    if [ $WP_DESCRIPTION ]; then
        $WP_CLI option update blogdescription "$WP_DESCRIPTION"
    fi

    if [ $WP_GMT_OFFSET ]; then
        $WP_CLI option update gmt_offset "$WP_GMT_OFFSET"
    fi

    if [ $WP_LANG ]; then
        $WP_CLI core language install $WP_LANG
        $WP_CLI core language activate $WP_LANG
    fi

    if [ $WP_REWRITE_STRUCTURE ]; then
        $WP_CLI rewrite structure "$WP_REWRITE_STRUCTURE"
    fi

    # create theme
    if [ ! -e "${DOC_ROOT}${WP_CONTENT_DIR}/themes/${WP_THEME}" ]; then
         $WP_CLI  scaffold _s ${WP_THEME} --theme_name="${WP_THEME}" --author="xeArts"  --sassify
    fi
    # Activate Theme.
    if [ $WP_THEME ]; then
        $WP_CLI theme activate "$WP_THEME"
    fi

    # Activate Plugins.
    $WP_CLI plugin activate --all

    # For Post Script.
    if [ -e "provision-post.sh" ]; then
        bash provision-post.sh
    fi

fi

#Move the index.php from ROOT folder to DOC_ROOT folder
cp ${ROOT}/index.php ${DOC_ROOT}/index.php