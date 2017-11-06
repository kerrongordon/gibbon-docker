FROM ubuntu:latest

# Install apache, PHP, and supplimentary programs. openssh-server, curl, and lynx-cur are for debugging the container.
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    apache2 php7.0 php7.0-mysql libapache2-mod-php7.0 curl lynx-cur php7.0-xml php7.0-zip php7.0-curl php7.0-gd \
    wget

# Enable apache mods.
RUN a2enmod php7.0
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Expose apache.
EXPOSE 80

# get Gibbon v13.0.02
RUN wget https://github.com/GibbonEdu/core/archive/v14.0.01.tar.gz

# extract files
RUN tar -xzf v14.0.01.tar.gz

# Copy this repo into place.
RUN cp -a /core-14.0.01/. /var/www/site

# Copy .htaccess
ADD .htaccess /var/www/site

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# Set permissions of all Gibbon files so they are not publicly writeable
RUN chmod -R 755 /var/www/site
RUN chown -R www-data:www-data /var/www/site

RUN rm -rf core-13.0.02
RUN rm -rf v13.0.02.tar.gz

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /usr/sbin/apache2ctl -D FOREGROUND
