FROM alpine:3.13

# Repository/Image Maintainer
LABEL maintainer="Leandro Henrique <emtudo@gmail.com>"

USER root

# Add the ENTRYPOINT script
COPY etc /etc
RUN mkdir /scripts
ADD start.sh /scripts/start.sh
ADD bashrc /home/app/.bashrc
ADD bashrc /home/bashrc

RUN  echo "---> INSTALL PHP" && \
  apk add --update \
  curl \
  poppler \
  # bash \
  #  fontconfig \
  libxrender \
  libxext \
  imagemagick \
  #  nano \
  vim \
  #  git \
  unzip \
  wget \
  # make \
  sudo

RUN echo "---> Preparing and Installing PHP" && \
  apk add --no-cache --update \
  php8 \
  php8-apcu \
  php8-bcmath \
  php8-bz2 \
  php8-calendar \
  php8-ctype \
  #  php8-cgi \
  php8-curl \
  php8-dom \
  php8-exif \
  php8-fpm \
  #  php8-ftp \
  php8-gd \
  php8-gmp \
  php8-iconv \
  php8-imagick \
  php8-imap \
  php8-intl \
  php8-mbstring \
  php8-memcached \
  #  php8-mongodb \
  #  php8-mysqli \
  #  php8-mysqlnd \
  php8-opcache \
  php8-openssl \
  php8-pcntl \
  php8-pdo_mysql \
  php8-pdo_pgsql \
  #  php8-pdo_sqlite \
  php8-pgsql \
  php8-phar \
  #  php8-phpdbg \
  php8-posix \
  php8-redis \
  php8-soap \
  #  php8-sockets \
  #  php8-swoole \
  php8-sodium \
  #  php8-sqlite3 \
  #  php8-xdebug \
  php8-xml \
  php8-xmlreader \
  #  php8-xsl \
  php8-zip \
  php8-zlib && \
  sudo ln -s /usr/bin/php8 /usr/bin/php && \
  #  sudo ln -s /usr/bin/php-cgi8 /usr/bin/php-cgi && \
  sudo ln -s /usr/sbin/php-fpm7 /usr/sbin/php-fpm && \
  echo "---> Installing Composer" && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --2 && \
  echo "---> Cleaning up" && \
  rm -rf /tmp/* && \
  echo "---> Adding the app user" && \
  adduser -D -u 1000 app && \
  mkdir -p /var/www/app && \
  chown -R app:app /var/www && \
  wget -O /tini https://github.com/krallin/tini/releases/download/v0.19.0/tini-static && \
  chmod +x /tini && \
  echo "---> Configuring PHP" && \
  echo "app  ALL = ( ALL ) NOPASSWD: ALL" >> /etc/sudoers && \
  sed -i "/user = .*/c\user = app" /etc/php8/php-fpm.d/www.conf && \
  sed -i "/^group = .*/c\group = app" /etc/php8/php-fpm.d/www.conf && \
  sed -i "/listen.owner = .*/c\listen.owner = app" /etc/php8/php-fpm.d/www.conf && \
  sed -i "/listen.group = .*/c\listen.group = app" /etc/php8/php-fpm.d/www.conf && \
  sed -i "/listen = .*/c\listen = [::]:9000" /etc/php8/php-fpm.d/www.conf && \
  sed -i "/;access.log = .*/c\access.log = /proc/self/fd/2" /etc/php8/php-fpm.d/www.conf && \
  sed -i "/;clear_env = .*/c\clear_env = no" /etc/php8/php-fpm.d/www.conf && \
  sed -i "/;catch_workers_output = .*/c\catch_workers_output = yes" /etc/php8/php-fpm.d/www.conf && \
  sed -i "/pid = .*/c\;pid = /run/php/php8.1-fpm.pid" /etc/php8/php-fpm.conf && \
  sed -i "/;daemonize = .*/c\daemonize = yes" /etc/php8/php-fpm.conf && \
  sed -i "/error_log = .*/c\error_log = /proc/self/fd/2" /etc/php8/php-fpm.conf && \
  sed -i "/post_max_size = .*/c\post_max_size = 1000M" /etc/php8/php.ini && \
  sed -i "/upload_max_filesize = .*/c\upload_max_filesize = 1000M" /etc/php8/php.ini && \
  # sed -i "/zend_extension=xdebug/c\;zend_extension=xdebug" /etc/php8/conf.d/00_xdebug.ini && \
  chown -R app:app /home/app && \
  chmod +x /scripts/start.sh && \
  rm -rf /tmp/*

RUN apk del curl

# iconv(): Wrong charset, conversion from `UTF-8' to `ASCII//TRANSLIT//IGNORE' is not allowed
RUN echo -e "\n # ---> Resolve problema com iconv \n" && \
  apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Supervisor
RUN echo -e "\n # ---> Installing Supervisor \n" && \
  apk add --no-cache --update supervisor

COPY supervisord.conf /etc/

# Application directory
WORKDIR "/var/www/app"

# Environment variables
ENV PATH=/home/app/.composer/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Copy nginx and entry script
COPY nginx.conf /etc/nginx/nginx.conf
COPY ssl.conf /etc/nginx/ssl.conf
COPY sites /etc/nginx/sites

# Install nginx from dotdeb (already enabled on base image)
RUN echo "--> Installing Nginx" && \
  apk add --update nginx openssl openssh-client && \
  rm -rf /tmp/* /var/tmp/* /usr/share/doc/* && \
  echo "--> Fixing permissions" && \
  mkdir /var/tmp/nginx && \
  mkdir /var/run/nginx && \
  mkdir /home/ssl && \
  chown -R app:app /home/ssl && \
  chown -R app:app /var/tmp/nginx && \
  chown -R app:app /var/run/nginx && \
  chown -R app:app /var/log/nginx && \
  chown -R app:app /var/lib/nginx && \
  chown -R app:app /home/app

# Pre generate some SSL
# YOU SHOULD REPLACE WITH YOUR OWN CERT.
RUN openssl req -x509 -nodes -days 3650 \
  -newkey rsa:2048 -keyout /home/ssl/nginx.key \
  -out /home/ssl/nginx.crt -subj "/C=AM/ST=app/L=app/O=app/CN=*.test" && \
  openssl dhparam -out /home/ssl/dhparam.pem 2048

COPY start.sh  /home/start.sh
COPY .ssh  /home/app/.ssh
COPY .ssh  /root/.ssh
RUN touch /root/.ssh/authorized_keys
RUN touch /root/.ssh/known_hosts

RUN echo "--> Ativar SSH"  && \
  chmod 700 /root/.ssh && \
  chmod 600 /root/.ssh/config && \
  chmod 644 /root/.ssh/known_hosts && \
  chmod 644 /root/.ssh/authorized_keys && \
  ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts && \
  ssh-keyscan -t rsa bitbucket.org >> /root/.ssh/known_hosts && \
  chown root:root /root/.ssh/* && \
  ssh-keygen -l -f /root/.ssh/known_hosts

# Variables for enabling
ENV OPCACHE_MODE="jit" \
  PHP_MEMORY_LIMIT=512M \
  TERM=xterm-256color \
  MIGRATE=true \
  COLORTERM=truecolor \
  COMPOSER_PROCESS_TIMEOUT=1200 \
  ENVIRONMENT=production

# Expose webserver port
EXPOSE 80
EXPOSE 443
EXPOSE 9000

# Define the entry point that tries to enable
ENTRYPOINT ["/tini", "--", "/scripts/start.sh"]

# As non daemon and single base image, it may be used as cli container
CMD ["production"]
