require 'spec_helper.rb'
require 'sidekiq/testing'
require_relative '../pusher.rb'

describe "My Sinatra Application" do
  it "should allow accessing the home page" do
    get '/'
    
    expect(last_response).to be_ok
  end
  
  it "should schedule push" do
    expect(Pusher.jobs.size).to eq(0)
    
    post '/schedule_push', {'date' => Time.now.to_i, 
                            'token' => '8bb578ed87a65923497700f89e26c0f567db0af30e219b84966224498a1fd53a', 
                            'message' => 'test'}
    
    expect(last_response).to be_ok
    
    json = JSON.parse(last_response.body)
    expect(json['result']).to eq('ok')
    
    expect(Pusher.jobs.size).to eq(1)
  end
end