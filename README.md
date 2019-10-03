# Getting Started

[![Build Status](https://travis-ci.org/kerrongordon/gibbon-docker.svg?branch=master)](https://travis-ci.org/kerrongordon/gibbon-docker) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/kerrongordon/gibbon) ![Docker Pulls](https://img.shields.io/docker/pulls/kerrongordon/gibbon) ![Docker Stars](https://img.shields.io/docker/stars/kerrongordon/gibbon)

Install [Docker](https://docs.docker.com/install/) on your system then clone this [repo](https://github.com/kerrongordon/gibbon-docker.git)

``` bash
git clone https://github.com/kerrongordon/gibbon-docker.git

cd gibbon-docker
```

## Create a *.env* file inside gibbon-docker folder

change database name, user and password

``` bash
MYSQL_DATABASE=db
MYSQL_USER=user
MYSQL_PASSWORD=password
MYSQL_ROOT_PASSWORD=password
```

## build Image

``` bash
docker build -t kerrongordon/gibbon .
```

## Start Docker Compose

``` bash
docker-compose up -d
```

Connect to database with *127.0.0.1* on port *3306*
open your web browser and go to [localhost](http://localhost/)

## Docker Compose example

``` yml
version: "3"
services:
  gibbon:
    image: kerrongordon/gibbon
    container_name: gibbon
    network_mode: host
    volumes:
      - my-gibbon:/var/www/site/
    ports:
      - 80:80
    restart: always

  db:
    image: mysql:5.7
    container_name: mysql
    restart: always
    environment:
      MYSQL_DATABASE: your-database-name // change me
      MYSQL_USER: your-user-name // change me
      MYSQL_PASSWORD: user-password // change me
      MYSQL_ROOT_PASSWORD: root-password // change me
    ports:
      - '3306:3306'
    expose:
      - '3306'
    volumes:
      - my-db:/var/lib/mysql

volumes:
  my-db:
  my-gibbon:
```
