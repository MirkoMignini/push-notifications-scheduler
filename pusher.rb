require './config/rpush.rb'

class Pusher
  include Sidekiq::Worker
  def perform(device_token, message)
    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name('ios_app')
    n.device_token = device_token
    n.alert = message
    n.data = { foo: :bar }
    n.save!
  end
end
