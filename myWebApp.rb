require 'sinatra'
require 'json'
require 'pp'

#set :port, 443
#set :port, 8080
#default is 4567
set :bind, 'webHooks4JSONParsing.expose'

# (0) sets the default value for key's with no value
$commitInfo = Hash.new(0)
# looks like
# {
#   repository 'name' => {
#     repoURL
#     commits{
#       {'message'(first line) => 'commitURL'}
#       {'secondCommitMessage' => www.githubYADAYADA}
#     }
#   }
#   repository2 'name' => {
#     repoURL
#     commits{
#       {'message'(first line) => 'commitURL'}
#       {'secondCommitMessage' => www.githubYADAYADA}
#     }
#   }
# }

post '/payload' do
  request.body.rewind
  payload_body = request.body.read
  # check SECRET_TOKEN
  verify_signature(payload_body)
  # convert JSON to Ruby hash
  push = JSON.parse(payload_body)
  getPushInfo(push)
end

get '/commitHTML' do
  getHTML()
end

def getHTML()

  return halt 200, "got the GET"
end

def getPushInfo(push_hash)
  # check if there is a repo with this name in the hash already
  if $commitInfo[push_hash['repository']['name']] = 0
    # add new repo info
    $commitInfo[push_hash['repository']['name']] = Hash.new(0)
    $commitInfo[push_hash['repository']['name']]['repoURL'] = push_hash['repository']['owner']['url']
    $commitInfo[push_hash['repository']['name']]['commits'] = Hash.new(0)
  end

  # get each commit's url and message
  for commit in push_hash['commits'] do
    # get only the first line of the commit message
    messageString = commit['message'].split("\n")[0]
    $commitInfo[push_hash['repository']['name']]['commits'][messageString] = commit['url']
  end
  pp $commitInfo
  return halt 200, "worked"

end

def verify_signature(payload_body)
  signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
  return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
end
