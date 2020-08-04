require 'sinatra'

get '/' do
  print "got test print"
  puts "got test puts"
  return halt 200, "got test return"
end
