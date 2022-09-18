# fattwiki

The current setup of this repository is that it holds configuration files and other things specific to the deployment of FattWiki. We don't currently edit code in the main Mediawiki repository, although that may change someday and this will get updated.

## Setup
Clone the repository and initialize the submodules:
```
git clone https://github.com/fattwiki/fattwiki.git
cd fattwiki
git submodule init
git submodule update
```
Create a file named ```.env``` in the project root:
```
WIKI_SERVER = http://localhost
APACHE_SERVER_NAME = localhost

MARIADB_SERVER = database
MARIADB_DATABASE = fattwiki
MARIADB_USER  = admin
# Passwords can be whatever you want
MARIADB_PASSWORD =
MARIADB_ROOT_PASSWORD =

# These keys can also be whatever strings you want
WIKI_SECRET_KEY =
WIKI_UPGRADE_KEY =

WIKI_EMAIL = test@email.com
WIKI_EMAIL_AUTHENTICATION = false
WIKI_EMAIL_CONFIRMTOEDIT = false
```

## Setup
Make sure you're executing from the project root.

Build the Docker image:
```
docker image build -t fattwiki .
```
Make the images and db folders to mount into the Docker container:
```
mkdir images db
```

Start the wiki:
```
docker-compose up
```

Initialize the database:
```
docker exec -i fattwiki-db sh -c 'exec mysql -uroot -p"$MARIADB_ROOT_PASSWORD" fattwiki' < database_dump.sql
```

Copy images into the /images directory.

Open http://localhost and you should see the wiki running there.

 ## Add extensions

In order to install extensions dynamically, I've put them all in install/extensions.txt.

To install a new extension on your Dockerized wiki:
1. Go to the Github page for the extension
2. Find the branch for Mediawiki 1.38 (usually called REL1_38)
3. Get the URL of the ZIP for that branch
4. Add a new line to extensions.txt that is the extension name and the ZIP path separated by a space
5. Update LocalSettings.php with whatever settings you need for the new extension
6. Rebuild your Docker image
7. Re-execute docker-compose up

## Goals
- Update skin (current skin is in [fattwiki/Vector](https://github.com/fattwiki/Vector))
- Modify VisualEditor?

## See also
- [MariaDB Dockerfile documentation](https://hub.docker.com/_/mariadb)
- [Mediawiki Dockerfile documentation](https://hub.docker.com/_/mediawiki)
