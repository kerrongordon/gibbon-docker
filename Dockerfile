FROM ubuntu:22.04

LABEL MAINTAINER Kerron Gordon <kgpsounds.com@gmail.com>

ENV VERSION=26.0.00
ENV GIBBON_URL="https://github.com/GibbonEdu/core/releases/download/v${VERSION}/GibbonEduCore-InstallBundle.tar.gz"
ENV INSTALL_DIR="/var/www/gibbon.local/"

WORKDIR ${INSTALL_DIR}
VOLUME ${INSTALL_DIR}

RUN apt-get update -y && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    php8.1 apache2 php8.1 php8.1-gd php8.1-mysql php8.1-zip php8.1-curl \
    php8.1-gettext php8.1-pdo php8.1-xml php8.1-mbstring php8.1-intl wget ca-certificates && \
    cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/gibbon.local.conf && \
    sed -i 's+/var/www/html+${INSTALL_DIR}+g' /etc/apache2/sites-available/gibbon.local.conf && \
    ln -s ../sites-available/gibbon.local.conf /etc/apache2/sites-enabled/gibbon.local.conf && \
    a2enmod rewrite && service apache2 restart && \
    mkdir -p ${INSTALL_DIR} && wget -c ${GIBBON_URL} -P /tmp/ && tar -xzf /tmp/GibbonEduCore-InstallBundle.tar.gz --directory ${INSTALL_DIR} && \
    chown -R www-data:www-data ${INSTALL_DIR} && chmod -R 755 ${INSTALL_DIR} && chmod -R 774 ${INSTALL_DIR}uploads && \
    sed -i 's/;max_input_vars = 1000/max_input_vars = 6000/' /etc/php/8.1/apache2/php.ini && \
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/' /etc/php/8.1/apache2/php.ini && \
    sed -i 's/post_max_size = 8M/post_max_size = 51M/' /etc/php/8.1/apache2/php.ini && \
    a2dissite 000-default.conf && service apache2 restart &&\
    rm -rf /tmp/* && \
    apt-get remove -y wget && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rfv /var/lib/{apt,dpkg,cache,log}

EXPOSE 80
CMD /usr/sbin/apache2ctl -D FOREGROUND
