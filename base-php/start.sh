#!/bin/sh

ACTION=$1

# Set PHP memory limit value.
sudo sed -i "/memory_limit = .*/c\memory_limit = $PHP_MEMORY_LIMIT" /etc/php8/php.ini

jit () {
  # enable extreme caching for OPCache.
  echo "opcache.enable=1" | sudo tee -a /etc/php8/conf.d/00_opcache.ini > /dev/null
  echo "opcache.memory_consumption=512" | sudo tee -a /etc/php8/conf.d/00_opcache.ini > /dev/null
  echo "opcache.interned_strings_buffer=128" | sudo tee -a /etc/php8/conf.d/00_opcache.ini > /dev/null
  echo "opcache.max_accelerated_files=32531" | sudo tee -a /etc/php8/conf.d/00_opcache.ini > /dev/null
  echo "opcache.validate_timestamps=0" | sudo tee -a /etc/php8/conf.d/00_opcache.ini > /dev/null
  echo "opcache.save_comments=1" | sudo tee -a /etc/php8/conf.d/00_opcache.ini > /dev/null
  echo "opcache.fast_shutdown=0" | sudo tee -a /etc/php8/conf.d/00_opcache.ini > /dev/null
  echo "opcache.jit_buffer_size=100M" | sudo tee -a /etc/php8/conf.d/00_opcache.ini > /dev/null
  echo "opcache.jit=1235" | sudo tee -a /etc/php8/conf.d/00_opcache.ini > /dev/null
  echo "opcache.jit_debug=0" | sudo tee -a /etc/php8/conf.d/00_opcache.ini > /dev/null
}

# OPCache disabled mode.
nocache () {
  # disable extension.
  sudo sed -i "/zend_extension=opcache/c\;zend_extension=opcache" /etc/php8/conf.d/00_opcache.ini
  # set enabled as zero, case extension still gets loaded (by other extension).
  echo "opcache.enable=0" | sudo tee -a /etc/php8/conf.d/00_opcache.ini > /dev/null
}

action_http () {
  # Starts FPM
  sudo nohup /usr/sbin/php-fpm8 -y /etc/php8/php-fpm.conf -F -O 2>&1 &
  sleep 5 &&
  echo "Entrando no NGINX"
  sudo nginx
  echo "Saindo do nginx"
}

action_supervisor () {
  echo "Supervisor Settings"
  [ -d /var/log/supervisor ] || mkdir -p /var/log/supervisor
  [ -d /var/www/app/storage/queues-log ] || mkdir -p /var/www/app/storage/queues-log
  sudo chown -R app:app /var/run
  sudo chown -R app:app /run
  echo -e "\n # ---> Crontab \n" && \
  (echo '* * * * * /usr/bin/php8 /var/www/app/artisan schedule:run') | crontab -
  sudo crond || sudo /usr/sbin/crond
  /usr/bin/supervisord -n -c /etc/supervisord.conf
}

banner () {
  echo "ACTION=$ACTION"
  echo "DB_CONNECTION=$DB_CONNECTION"
  echo "DB_HOST=$DB_HOST"
  echo "DB_PORT=$DB_PORT"
  echo "DB_DATABASE=$DB_DATABASE"
  echo "DB_USERNAME=$DB_USERNAME"
}

case $ACTION in
  production)
    banner && jit && action_http
  ;;
  queue_production)
    banner && jit && action_supervisor
  ;;
  dev)
   banner && nocache && action_http
  ;;
  queue_dev)
    banner && nocache && action_supervisor
  ;;
  *)
    exec "$@";;
esac
