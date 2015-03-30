require 'sinatra'
require 'json'

get '/' do
  "Hello World!"
end


get '/alligator' do
  body = JSON.pretty_generate({:name => "Betty"})
  headers = {"Content-Type" => "application/json"}
  [200, headers, body]
end
