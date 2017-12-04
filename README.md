php快速开发环境搭建
---
* ubuntu 16.10
* php7 mysql5.6 nginx
* composer
* laravel

---
mysql
* user:`root`
* password:`123456`

Get start
---
1. install docker
```
cd {project}
git clone git@github.com:Vestin/php-dev-dockerfile.git dev
```

2. modify Dockerfile fit your need & build
```
 cd {project}/dev
 sudo docker build -t {image_name} .
```
3. create container
```
sudo docker run -itd --name {container_name} -v {ProjectPath}:/var/www/html {image_name}
```
* ProjectPath: 本地项目路径

4. run container
```
sudo docker start {container_name}
```

5. cd container
```
sudo docker exec -it {contaienr_name} /bin/bash
```

6. run web
```
nginx
php-fpm
service mysql start
...
```