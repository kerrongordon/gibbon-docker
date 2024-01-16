# Getting Started

[![Build Status](https://travis-ci.org/kerrongordon/gibbon-docker.svg?branch=master)](https://travis-ci.org/kerrongordon/gibbon-docker) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/kerrongordon/gibbon) ![Docker Pulls](https://img.shields.io/docker/pulls/kerrongordon/gibbon) ![Docker Stars](https://img.shields.io/docker/stars/kerrongordon/gibbon)

Install [Docker](https://docs.docker.com/install/) on your system then clone this [repo](https://github.com/kerrongordon/gibbon-docker.git)

## FOR DEMO USE ONLY DO NOT USE IN PRODUCTION

``` bash
git clone https://github.com/kerrongordon/gibbon-docker.git

cd gibbon-docker
```

## Create a *.env* file

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
    image: kerrongordon/gibbon:latest
    container_name: gibbon
    restart: unless-stopped
    ports:
      - 8080:80
    volumes:
      - my-gibbon:/var/www/gibbon.local/
    depends_on:
      - db

  db:
    image: mysql:latest
    container_name: mysql
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
    ports:
      - '3306:3306'
    volumes:
      - my-db:/var/lib/mysql

volumes:
  my-db:
  my-gibbon:
```
