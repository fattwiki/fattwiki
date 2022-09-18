#!/bin/bash
# Install extensions that don't come by default

mkdir /opt/ziptemp

while IFS=$' \r\n' read extname zipurl; do
  cd /opt
  echo "Installing ${extname}..."
  zipname=$extname.zip
  curl -L -o $zipname $zipurl
  unzip $zipname -d /opt/ziptemp
  mv ziptemp/$(ls ziptemp) $WIKI_PATH/extensions/$extname
  rm $zipname
  cd $WIKI_PATH/extensions/$extname
  composer install --no-dev
done < extensions.txt

rm -rf /opt/ziptemp

cd /opt

if [ $ENV = "dev" ]
then
  cp 000-default.dev.conf /etc/apache2/sites-available/000-default.conf
fi

# Production installation
if [ $ENV = "prod" ]
then
  cp 000-default.prod.conf /etc/apache2/sites-available/000-default.conf
  if [ -d /opt/secrets ]
  then
    cd /opt/secrets
    cp fatt_wiki.crt /etc/ssl/certs/fatt_wiki.crt
    cp server.key /etc/ssl/server.key
    cp fatt_wiki.ca-bundle /etc/ssl/certs/fatt_wiki.ca-bundle
    mv .well-known /var/www/html/.well-known
  else
    echo "Can't find secrets for this production installation!"
  fi
fi