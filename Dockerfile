FROM ubuntu

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install nginx -y
RUN apt-get install php-fpm php-mysql php-dom php-curl php-imagick php-gd php-zip -y
RUN apt-get install composer -y
RUN apt-get install autoconf zlib1g-dev php-dev php-pear -y
RUN apt-get install supervisor -y
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pecl install grpc
RUN echo "extension=grpc.so" >> /etc/php/7.4/fpm/php.ini
RUN echo "extension=grpc.so" >> /etc/php/7.4/cli/php.ini

RUN pecl install protobuf
RUN echo "extension=protobuf.so" >> /etc/php/7.4/fpm/php.ini
RUN echo "extension=protobuf.so" >> /etc/php/7.4/cli/php.ini

COPY vhost.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisord.conf

RUN cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
RUN sed 's/www-data/root/g' /etc/nginx/nginx.conf.bak > /etc/nginx/nginx.conf

RUN mkdir -p /var/log/php-fpm
RUN chown -R www-data:www-data /run/php /var/log/php-fpm

EXPOSE 8080

ENTRYPOINT /usr/bin/supervisord -u root -n]
