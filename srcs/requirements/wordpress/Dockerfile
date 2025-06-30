
FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    default-mysql-client \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/run/php && chown -R www-data:www-data /var/run/php

RUN mkdir -p /var/www/html \
    && curl -O https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz -C /var/www/html --strip-components=1 \
    && rm latest.tar.gz

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

EXPOSE 9000

CMD ["/entrypoint.sh"]
