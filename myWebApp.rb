require 'sinatra'
require 'json'

#set :port, 443
#set :port, 3030
#set :port, 8080
#set :port, 4040
#default is 4567
set :bind, 'webHooks4JSONParsing.expose'

print "running Ruby Script\n"
# catches payload push and gets the JSON
post '/payload' do
#post '/' do
  print "in payload\n"
  push = JSON.parse(request.body.read)
  puts "I got some JSON! #{push.inspect}"
end

# TODO: need to add SECRET to secure webhook
