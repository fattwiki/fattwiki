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