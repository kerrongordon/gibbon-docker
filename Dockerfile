FROM ubuntu:18.04

MAINTAINER Kerron Gordon <kgpsounds.com@gmail.com>

# Install apache, PHP, and supplimentary programs. openssh-server, curl, and lynx-cur are for debugging the container.
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git \
    wget \
    curl \
    lynx \
    php7.2 \
    locales \
    apache2 \
    php7.2-gd \
    php7.2-xml \
    php7.2-zip \
    php7.2-curl \
    php7.2-mysql \
    php7.2-mbstring \
    ca-certificates \
    libapache2-mod-php7.2

# Enable apache mods.
# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN a2enmod php7.2 && a2enmod rewrite && \
    sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php/7.2/apache2/php.ini && \
    sed -i 's/magic_quotes_gpc = On/magic_quotes_gpc = Off/g' /etc/php/7.2/apache2/php.ini && \
    sed -i "s/^allow_url_fopen.*$/allow_url_fopen = On/" /etc/php/7.2/apache2/php.ini && \
    sed -i 's/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/' /etc/php/7.2/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Expose apache.
EXPOSE 80

# get Gibbon v18.0.00 (Bo Lo Bao)
RUN wget -c https://github.com/GibbonEdu/core/archive/v18.0.00.tar.gz

# extract files
# Copy this repo into place.
RUN tar -xzf v18.0.00.tar.gz && cp -a /core-18.0.00/. /var/www/site

#get all i18n files  
RUN git clone https://github.com/GibbonEdu/i18n.git ./var/www/site/i18n

# Copy .htaccess
ADD .htaccess /var/www/site

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# Set permissions of all Gibbon files so they are not publicly writeable
RUN chmod -R 755 /var/www/site && chown -R www-data:www-data /var/www/site

# clean up time
RUN rm -rf core-18.0.00 && \
    rm -rf v18.0.00.tar.gz && \
    apt-get remove -y wget && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /usr/sbin/apache2ctl -D FOREGROUND
