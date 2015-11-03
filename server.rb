require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq/web'
require 'json'
require './pusher.rb'

class Server < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  
  configure :development do
    register Sinatra::Reloader
  end
  
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
  
  post '/schedule' do
    content_type :json
    
    begin
      raise ArgumentError('Platform argument is required') unless params.include?('platform')
      raise ArgumentError('Platform is not apns, gcm, adm or wpns.') unless %w(apns gcm adm wpns).include?(params['platform'])
      raise ArgumentError('Application argument is required') unless params.include?('app')
      raise ArgumentError('Device argument is required') unless params.include?('device')
      raise ArgumentError('Date argument is required') unless params.include?('date')
      
      date = Time.at(params['date'].to_i)
      platform = params['platform']
      app = params['app']
      device = params['device']
      message = params.include?('message') ? params['message'] : nil
      data = params.include?('data') ? params['data'] : nil
      
      Pusher.perform_at(date.to_i, platform, app, device, message, data)
      
    rescue Exception => e
      
      return {result: 'ko', error: e.to_s}.to_json  
      
    end
    
    {result: 'ok'}.to_json
  end
end
