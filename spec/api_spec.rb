require 'spec_helper.rb'
require 'sidekiq/testing'
require_relative '../pusher.rb'

describe "Server" do
  
  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_ok
  end
  
  describe '/schedule' do
    
    context 'valid params' do
      
      subject(:schedule_valid) do
        post '/schedule', { 
                            date: Time.now.to_i, 
                            platform: 'apns',
                            app: 'ios_app',
                            device: 'device_token',
                            message: 'test',
                            data: {}
                          }
      end
    
      it 'responds with 200' do
        schedule_valid
        expect(last_response).to be_ok
      end

      it 'responds with json' do
        schedule_valid
        expect(last_response.header['Content-Type']).to eq('application/json')
      end

      it 'responds json ok' do
        schedule_valid
        json = JSON.parse(last_response.body)
        expect(json['result']).to eq('ok')
      end    
      
      it 'add job to queue' do
        expect {
          schedule_valid
        }.to change{ Pusher.jobs.size }.by(1)
      end
    
    end
    
    context 'not valid params' do
      
      subject(:schedule_not_valid) do
        post '/schedule'
      end
      
      it 'responds json ko' do
        schedule_not_valid
        json = JSON.parse(last_response.body)
        expect(json['result']).to eq('ko')
      end  
      
      it 'does not add job to queue' do
        expect {
          schedule_not_valid
        }.to change{ Pusher.jobs.size }.by(0)
      end
    
    end
    
  end
end