#!/bin/sh
wget https://raw.githubusercontent.com/dokku/dokku/v0.28.4/bootstrap.sh
sudo DOKKU_TAG=v0.28.4 bash bootstrap.sh
# on 0.19.x+
sudo dokku plugin:install https://github.com/dokku/dokku-mysql.git mysql
# on 0.19.x+
sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres
# on 0.19.x+
sudo dokku plugin:install https://github.com/dokku/dokku-mongo.git mongo
# on 0.19.x+
sudo dokku plugin:install https://github.com/dokku/dokku-redis.git redis
# on 0.19.x+
sudo dokku plugin:install https://github.com/dokku/dokku-rabbitmq.git rabbitmq

sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

dokku apps:create xpressci
dokku redis:create xpressci --password x1204re --root-password x1204re
dokku redis:link xpressci xpressci
dokku mysql:create xpressci --image-version 5.7.28 --password x1204ci --root-password x1204ci
dokku mysql:link xpressci xpressci

echo Enter your admin login credentials, you will use this to login into the platform when the installation is complete.

read -p 'Email: ' uservar
read -p 'Password: ' passvar

echo Enter your xpressci installation server ip address

read -p 'IP: ' tld

dokku domains:clear-global $tld  
dokku domains:add-global $tld
dokku domains:set-global $tld

dokku config:set --no-restart xpressci APP_KEY=base64:C5ulYcIxKUPyHduCG6Ftd99dE61o36NciXKpqUXP0ww= ADMIN_EMAIL=$uservar ADMIN_PASSWORD=$passvar BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-php DB_CONNECTION=mysql DB_HOST=dokku-mysql-xpressci DB_PORT=3306 DB_DATABASE=xpressci DB_USERNAME=root DB_PASSWORD=x1204ci CACHE_DRIVER=file SESSION_DRIVER=file SESSION_LIFETIME=120 QUEUE_DRIVER=redis REDIS_HOST=dokku-redis-xpressci REDIS_PASSWORD=x1204re REDIS_PORT=6379
dokku git:sync --build xpressci https://aadags@bitbucket.org/aadags/xpressdeploy.git master

echo Installation is complete.
