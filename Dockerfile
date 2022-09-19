FROM mediawiki:1.38
WORKDIR /opt

RUN apt-get update; apt-get install unzip
RUN a2enmod ssl

# Change the wiki's root path (it just seems to work better in a subdirectory of /var/www/html)
RUN cd /var/www; mv html wiki; mkdir html; mv wiki html/wiki
ENV WIKI_PATH /var/www/html/wiki

COPY ./install/* /opt/

# Install Composer, we'll need it for extensions
# See https://getcomposer.org/download/
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"; \
    php composer-setup.php; \
    php -r "unlink('composer-setup.php');"; \
    mv composer.phar /usr/local/bin/composer

# Install extensions
RUN bash install.sh

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY favicon.ico $WIKI_PATH/favicon.ico

CMD apache2-foreground