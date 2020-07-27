require 'sinatra'
require 'json'

#set :port, 443
#set :port, 8080
#default is 4567
set :bind, 'webHooks4JSONParsing.expose'

post '/payload' do
  request.body.rewind
  print "\n ONE \n"
  payload_body = request.body.read
  print "\n TWO \n"
  verify_signature(payload_body)
  print "\n FOUR \n"
  push = JSON.parse(payload_body)
  print "\n FIVE \n"
  puts JSON.pretty_generate(push)
end

def verify_signature(payload_body)
  signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
  print "\n THREE \n"
  return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
end

# TODO: need to add SECRET to secure webhook
