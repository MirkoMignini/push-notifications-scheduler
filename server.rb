require 'sinatra/base'
require 'sinatra/activerecord'
require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq/web'
require 'json'
require './pusher.rb'

class Server < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  
  get '/' do    
    stats = Sidekiq::Stats.new
    workers = Sidekiq::Workers.new
    "
    <p>Processed: #{stats.processed}</p>
    <p>In Progress: #{workers.size}</p>
    <p>Enqueued: #{stats.enqueued}</p>
    <p><a href='/'>Refresh</a></p>
    <p><a href='/sidekiq'>Dashboard</a></p>
    "
  end

  post '/schedule_push' do
    content_type :json
    
    begin
      date = Time.at(params['date'].to_i)
      device_token = params['device_token']
      message = params['message']
      Pusher.perform_at(date.to_i, device_token, message)
      #Pusher.perform_async(device_token, message)
    rescue Exception => e
      return {result: 'ko', error: e.to_s}.to_json  
    end
    
    {result: 'ok'}.to_json
  end
end
