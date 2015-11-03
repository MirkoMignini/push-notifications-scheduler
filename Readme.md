# Push notifications scheduler

>This is a work in progress project, not ready for production yet.

## Introduction

This server expose a simple api to schedule the send of a push notification. The system use [rpush](https://github.com/rpush/rpush) so it's compatible with the following services:

* Apple Push Notification Service
* Google Cloud Messaging
* Amazon Device Messaging
* Windows Phone Push Notification Service

## Technologies used

* [Sinatra](http://www.sinatrarb.com/) as framework
* [Sidekiq](http://sidekiq.org/) as queue manager
* [Rpush](https://github.com/rpush/rpush) as push manager

## Getting started

1. Before start is it necessary to register one or more app, there is a command line tool to simplify this process but please refer to [rpush](https://github.com/rpush/rpush) docs for details:
```shell
ruby register_app.rb --help
```
3. Start redis, [(how to install and start redis)](http://redis.io/topics/quickstart)
```shell
redis-server
```
3. Start web server
```shell
bundle exec rackup
```
4. Start sidekiq
```shell
bundle exec sidekiq -r ./server.rb
```
5. Start rpush service
```shell
bundle exec rpush start
```

## How to use
TODO

## Credits
[Thanks to p8952 for sinatra sidekiq integration sample code](https://github.com/p8952/sinatra-sidekiq)