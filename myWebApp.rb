require 'sinatra'
require 'json'


# catches payload push and gets the JSON
post '/payload' do
  push = JSON.parse(request.body.read)
  puts "I got some JSON: #{push.inspect}"
end

# TODO: need to add SECRET to secure webhook
