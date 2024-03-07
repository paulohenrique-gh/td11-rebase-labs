require 'sinatra'
require 'rack/handler/puma'

set :port, 4000

get '/' do
  content_type 'text/html'

  File.open('index.html')
end
