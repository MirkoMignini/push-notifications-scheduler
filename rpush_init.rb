require 'optparse'
require './config/rpush.rb'

Options = Struct.new(:app_name, :cert_file, :cert_password, :environment)

class Parser
  def self.parse(options)
    args = Options.new()
    
    args.environment = 'sandbox'

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: rpush_init.rb [options]"

      opts.on("-n", "--name NAME", "App name") do |app_name|
        args.app_name = app_name
      end
      
      opts.on("-c", "--cert FILE", "Certificate file path") do |cert_file|
        args.cert_file = cert_file
      end
      
      opts.on("-p", "--pass PASS", "Certificate password") do |cert_password|
        args.cert_password = cert_password
      end
      
      opts.on("-e", "--env [ENV]", "Environment, default is sandbox") do |environment|
        args.environment = environment
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
        options.cert_file.nil? or
        options.cert_password.nil?)
  
  app = Rpush::Apns::App.new
  app.name = options.app_name
  app.certificate = File.read(options.cert_file)
  app.environment = options.environment
  app.password = options.cert_password
  app.connections = 1
  app.save!
  
  p "Application #{options.app_name} created."
end