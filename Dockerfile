FROM library/ubuntu:16.10

# 修改成阿里源
ADD ./sources.list /etc/apt
RUN apt-get update

RUN apt-get -y install php

# install nginx && add vhost for unknow
RUN apt-get -y install nginx
ADD ./nginx/web /etc/nginx/sites-enabled/

RUN apt-get -y install curl
RUN apt-get -y install zip
RUN apt-get -y install git
RUN apt-get -y install vim
RUN apt-get -y remove apache

RUN echo "mysql-server mysql-server/root_password password 123456" | debconf-set-selections && \
echo "mysql-server mysql-server/root_password_again password 123456" | debconf-set-selections  && \
apt-get -y install mysql-server && \
service mysql start
RUN echo "bind-address            = 0.0.0.0" >> /etc/mysql/mysql.conf.d/mysqld.cnf && service mysql restart
#RUN mysql -uroot -p123456 -e"grant all privileges on *.*  to  'root'@'%'  identified by '123456'  with grant option;flush privileges;"
# 为php-fpm创建运行文件夹
RUN mkdir /run/php
RUN apt-get -y install php7.0-curl php7.0-gd php7.0-mysql php7.0-mbstring php7.0-zip php7.0-xml php7.0-fpm
RUN apt-get -y autoremove apache2

RUN nginx
RUN php-fpm7.0
RUN service mysql start

# composer install
RUN php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" && \
php composer-setup.php && \
php -r "unlink('composer-setup.php');" && \
mv composer.phar /usr/local/bin/composer && \
composer config -g repo.packagist composer https://packagist.phpcomposer.com && \
composer self-update
# 添加composer path
ENV PATH="/root/.composer/vendor/bin:${PATH}"

RUN composer global require "laravel/installer"

#clean
RUN apt-get clean
