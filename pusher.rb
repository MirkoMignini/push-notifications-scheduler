require './config/rpush.rb'

class Pusher
  include Sidekiq::Worker
  def perform(platform, app, device, message = nil, data = nil)
    case platform
      when 'apns'
        n = Rpush::Apns::Notification.new
        n.app = Rpush::Apns::App.find_by_name(app)
        n.device_token = device
        n.alert = message
        n.data = data
      when 'gcm'
        n = Rpush::Gcm::Notification.new
        n.app = Rpush::Gcm::App.find_by_name(app)
        n.registration_ids = [device]
        n.data = { message: data }
      when 'adm'
        n = Rpush::Adm::Notification.new
        n.app = Rpush::Adm::App.find_by_name(app)
        n.registration_ids = [device]
        n.data = { message: data }
      when 'wpns'
        n = Rpush::Wpns::Notification.new
        n.app = Rpush::Wpns::App.find_by_name(app)
        n.uri = device
        n.data = data
    end
    n.save!
  end
end
