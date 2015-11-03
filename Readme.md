# Push notifications scheduler

## How to start

```shell
service redis start - or - /etc/init.d/redis start
bundle exec rackup
bundle exec sidekiq -r ./server.rb
bundle exec rpush start - or - rpush push (Rpush will deliver all pending notifications and then exit)
```

[Thanks to p8952 for sinatra sidekiq integration sample code](https://github.com/p8952/sinatra-sidekiq)
