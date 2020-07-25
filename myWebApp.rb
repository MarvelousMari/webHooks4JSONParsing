require 'sinatra'
require 'json'

#set :port, 443
#set :port, 3030
#set :port, 8080
#set :port, 4040
#default is 4567
set :bind, 'webHooks4JSONParsing.expose'

post '/payload' do
  request.body.rewind
  payload_body = request.body.read
  verify_signature(payload_body)
  push = JSON.parse(params[:payload])
  "I got some JSON: #{push.inspect}"
end

def verify_signature(payload_body)
  signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
  return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
end

# TODO: need to add SECRET to secure webhook
