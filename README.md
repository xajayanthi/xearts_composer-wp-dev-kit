# Composer WordPress Development Kit.

WordPress Environment for PHP Built-in Server.

## Getting Started

### 1. Installation of PHP, composer, WP-CLI, MySQL , yq, cURL.


PHP and cURL are pre-installed in Mac OS. 

If  Composer, WP-CLI, MySQL , yq are not installed ,install through brew command

$ brew install composer 
$ brew install wp-cli 
$ brew install mysql 
$ brew install yq 



### 2. Create Project


$ composer create-project xajayanthi/xearts_composer-wp-dev-kit path/to/project

If xearts_composer-wp-dev-kit is not registered in  packagist.org,execute the below to create project 

First GIT clone xajayanthi/xearts_composer-wp-dev-kit to local folder (path/to/GITClonePath)

and then execute the following commands
$ composer clear-cache 
$ composer create-project  --repository path/to/GITClonePath/packages.json  xajayanthi/xearts_composer-wp-dev-kit path/to/project


### 3. Start Development!

$ cd path/to/project

Note:Before executing the below command,Update the env-sample.json file for environment variables

$ composer create-env
$ vi .env.json
$ mysql.server start
$ composer provision



./bin/provision.sh` create database and install WordPress if is not installed.

#### Start WordPress!

$ composer server



## Directory & Files.

`.` Document root.
`./wp` WordPress core files.
`./wp-content` Custom wp-content.
`./wp-content/mu-plugins/vendor` for composer library.
`.env.json` setting your environment.

## Commands

composer create-env --  create .env.json
composer provision -- Provisioning WordPress.
composer server -- Start wp server and open browser.
composer import-theme-unit-test -- Import theme unit test data. (Not used in Xearts)
composer create-production-config -- create config.php (Not Used in Xearts)


