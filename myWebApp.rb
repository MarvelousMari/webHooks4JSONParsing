require 'sinatra'
require 'json'

#set :port, 443
#set :port, 8080
#default is 4567
set :bind, 'webHooks4JSONParsing.expose'

post '/payload' do
  request.body.rewind
  payload_body = request.body.read
  # check SECRET_TOKEN
  verify_signature(payload_body)
  # convert JSON to Ruby hash
  push = JSON.parse(payload_body)
  getCommitInfo(push)
end

def getCommitInfo(push_hash)
  # get Repository name
  print "\n" + push_hash['repository']['name'] + "\n"
  # get the url for the repository
  print push_hash['repository']['owner']['url'] + "\n"
  # get each commit's url and message
  for commit in push_hash['commits'] do
    print "\n" + commit['url'] + "\n"
    print commit['message']
    print "\n" + "\n"
  end
  return halt 200, "worked"
end

def verify_signature(payload_body)
  signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
  print "\n THREE \n"
  return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
end
