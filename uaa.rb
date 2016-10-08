require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'json'
#require 'redis'
require 'sinatra/base'
require 'rest-client'

class UaaApp < Sinatra::Base

$stdout.sync = true


$client = 'testclient'
$secret = 'testclient'
$base_auth = 'dGVzdGNsaWVudDp0ZXN0Y2xpZW50'

def get_services
  @services = JSON.parse(ENV['VCAP_SERVICES'])
  puts @services
end

def get_uaa
  get_services
  @uaa = @services['predix-uaa'].first
  puts @uaa
  
  @uaa_uri      = @uaa['credentials']['uri']
  @uaa_issuerid = @uaa['credentials']['issuerId']
  @uaa_name     = @uaa['name']

  puts @uaa_issuerid

end


get '/' do
  "#{ENV['VCAP_SERVICES']}"
end

get '/login' do
  get_uaa

  body = "username=#{params['username']}&password=#{params['password']}&grant_type=password"
  headers = {'authorization' => "Basic #{$base_auth}"}
  
  puts body
  puts headers

  res = RestClient.post("#{@uaa_issuerid}", body, headers)
  puts res.code
  puts res.headers
  puts res.body
  
  res
end

end
