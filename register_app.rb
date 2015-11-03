require 'optparse'
require './config/rpush.rb'

Options = Struct.new(:device, :app_name, :cert_file, :cert_password, :environment, :client_id, :client_secret, :auth_key)

class Parser
  def self.parse(options)
    args = Options.new()
    
    args.environment = 'sandbox'

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: register_app.rb -d DEVICE -n APP_NAME [options]"

      opts.on("-d", "--device DEV", "Device (apns, gcm, adm or wpns)") do |device|
        args.device = device
      end
      
      opts.on("-n", "--name APP_NAME", "App name") do |app_name|
        args.app_name = app_name
      end
      
      opts.on("-c", "--cert [FILE]", "Certificate file path") do |cert_file|
        args.cert_file = cert_file
      end
      
      opts.on("-p", "--pass [PASS]", "Certificate password") do |cert_password|
        args.cert_password = cert_password
      end
      
      opts.on("-e", "--env [ENV]", "Environment, default is sandbox") do |environment|
        args.environment = environment
      end
      
      opts.on("-i", "--id [CLIENT_ID]", "Client ID") do |client_id|
        args.client_id = client_id
      end
      
      opts.on("-s", "--secret [CLIENT_SECRET]", "Client secret") do |client_secret|
        args.client_secret = client_secret
      end
      
      opts.on("-a", "--auth [AUTH_KEY]", "Authorization key") do |auth_key|
        args.auth_key = auth_key
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
    return args
  end
end
options = Parser.parse ARGV

unless (options.app_name.nil? or
        options.device.nil?)
  
  case options.device
    when 'apns'
      app = Rpush::Apns::App.new
      app.certificate = File.read(options.cert_file)
      app.environment = options.environment
      app.password = options.cert_password
    when 'gcm'
      app = Rpush::Gcm::App.new
      app.auth_key = options.auth_key
    when 'adm'
      app = Rpush::Adm::App.new
      app.client_id = options.client_id
      app.client_secret = options.client_secret
    when 'wpns'
      app = Rpush::Wpns::App.new
      app.client_id = options.client_id
      app.client_secret = options.client_secret
  end
  
  app.name = options.app_name
  app.connections = 1
  app.save!
  
  p "Application #{options.app_name} created."
end