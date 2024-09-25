FROM php:apache

USER root

ARG OC_VERSION="7.41"

COPY openconf-${OC_VERSION}.zip /tmp

RUN set -x; apt-get update && apt-get -yq upgrade && \
    apt-get install -yq --no-install-recommends \
    vim unzip gettext zlib1g-dev libxml2-dev task-japanese locales exim4 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
#RUN docker-php-ext-install json mysqli xml zip gettext
RUN docker-php-ext-install mysqli
RUN cd /tmp && unzip openconf-${OC_VERSION}.zip && \
    cd /var/www/ && rmdir html && mv /tmp/openconf html && \
    chown -R www-data:www-data html

COPY mail.ini /usr/local/etc/php/conf.d
COPY update-exim4.conf.conf /etc/exim4
COPY passwd.client /etc/exim4

RUN update-exim4.conf
