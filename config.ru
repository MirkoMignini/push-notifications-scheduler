require './server.rb'

run Rack::URLMap.new('/' => Server, '/sidekiq' => Sidekiq::Web)
