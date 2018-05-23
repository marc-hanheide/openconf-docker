FROM php:apache

MAINTAINER mnagaku

USER root

ARG OC_VERSION="6.81"

COPY openconf-${OC_VERSION}.zip /tmp

RUN apt-get update && apt-get -yq upgrade && \
    apt-get install -yq --no-install-recommends \
    vim unzip gettext zlib1g-dev libxml2-dev task-japanese locales exim4 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-install mbstring json mysqli xml zip gettext && \
    echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && update-locale LANG=ja_JP.utf8 && \
    cd /tmp && unzip openconf-${OC_VERSION}.zip && \
    cd /var/www/ && rmdir html && mv /tmp/openconf html && \
    chown -R www-data:www-data html

COPY mail.ini /usr/local/etc/php/conf.d
COPY update-exim4.conf.conf /etc/exim4
COPY passwd.client /etc/exim4

RUN update-exim4.conf
