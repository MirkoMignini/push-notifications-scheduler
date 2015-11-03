# Push notifications scheduler

>This is a work in progress project, not ready for production yet.

## Introduction

This server expose a simple api to schedule the send of a push notification. The system use [rpush](https://github.com/rpush/rpush) so it's compatible with the following services:

* [**Apple Push Notification Service**](#apple-push-notification-service)
* [**Google Cloud Messaging**](#google-cloud-messaging)
* [**Amazon Device Messaging**](#amazon-device-messaging)
* [**Windows Phone Push Notification Service**](#windows-phone-notification-service) 

## Technologies used

* [Sinatra](http://www.sinatrarb.com/) as framework
* [Sidekiq](http://sidekiq.org/) as queue manager
* [Rpush](https://github.com/rpush/rpush) as push manager

## Getting started

1. Before start is it necessary to register one or more app, there is a command line tool to simplify this process but please refer to [rpush](https://github.com/rpush/rpush) docs for details:
```shell
ruby register_app.rb --help
```
2. Start web server
```shell
bundle exec rackup
```
3. Start sidekiq
```shell
bundle exec sidekiq -r ./server.rb
```
4. Start rpush service
```shell
bundle exec rpush start
```

## How to use
TODO

## Credits
[Thanks to p8952 for sinatra sidekiq integration sample code](https://github.com/p8952/sinatra-sidekiq)