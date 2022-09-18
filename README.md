# fattwiki

The current setup of this repository is that it holds configuration files and other things specific to the deployment of FattWiki. We don't currently edit code in the main Mediawiki repository, although that may change someday and this will get updated.

## Setup
Clone the repository and initialize the submodules:
```
git clone https://github.com/fattwiki/fattwiki.git
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
```

## Setup

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
mysql --port=3306 -u $DB_USER -p $DB_PASS $DB_NAME < database_dump.sql
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

Currently, the only Mediawiki code I've edited is the skin. I've made very minimal edits and the majority of the CSS for the wiki can be seen at [Mediawiki:Common.css](https://fatt.wiki/view/MediaWiki:Common.css).

 My goal is to move the skin-related CSS into the skin itself, and to make the skin more maintainable instead of just a slapdash edit of Mediawiki's default skin ([Vector 2022](https://www.mediawiki.org/wiki/Skin:Vector/2022)).

