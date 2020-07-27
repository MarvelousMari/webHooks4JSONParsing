require 'sinatra'
require 'json'
require 'pp'

#set :port, 443
#set :port, 8080
#default is 4567
set :bind, 'webHooks4JSONParsing.expose'
$commitInfo = Hash.new()
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
  html2Return = "<ul>\n\t"
  # get the repo name create a link with the message for text and connect it to repository link
  # and set that to the first list line
  $commitInfo.each{|repository, repoVal| html2Return += "<li><a href=\"" + repoVal['repoURL'] + "\">" + repository + "</a><ul>\n"
    # get each commit first line message and set it as a link to the commit page
    # then added it as a sub bullet to the repoName list
    repoVal['commits'].each{|message, commitURL| html2Return += "\t\t" + "<li><a href=\"" + commitURL + "\">" + message + "</a></li>\n"}
    # end the list
    html2Return += "\t</ul></li>\n"}
  # end the bloc
  html2Return += "</ul>"
  puts html2Return
  return halt 200, html2Return
end

def getPushInfo(push_hash)
  # check if there is a repo with this name in the hash already
  if $commitInfo[push_hash['repository']['name']].nil?
    # add new repo info
    $commitInfo[push_hash['repository']['name']] = Hash.new()
    $commitInfo[push_hash['repository']['name']]['repoURL'] = push_hash['repository']['owner']['url']
    $commitInfo[push_hash['repository']['name']]['commits'] = Hash.new()
  end

  # get each commit's url and message
  for commit in push_hash['commits'] do
    # get only the first line of the commit message
    messageString = commit['message'].split("\n")[0]
    $commitInfo[push_hash['repository']['name']]['commits'][messageString] = commit['url']
  end
  pp $commitInfo
  return halt 200, "got push info"

end

# check SECRET_TOKEN Enviorment/server variable
def verify_signature(payload_body)
  signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
  return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
end
