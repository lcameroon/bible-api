require 'sinatra'
require 'json'

set :public_folder, "public"

# Cache Control (1 week = 604800)
before do
  cache_control :public, :must_revalidate, :max_age => 36000
end

# Home
get '/' do
  erb :index
end

# API
get '/api' do
  content_type :json
  js_file = 'books.js'
  file = File.read( File.join(settings.public_folder, js_file ))
  file.gsub('./?book=', request.url + '/')
end

get '/api/:book' do
  content_type :json
  js_file = params[:book] + '/' + params[:book] + '.js'
  file = File.read( File.join(settings.public_folder, js_file) )
  file.gsub('./?book='+ params[:book] +'&chapter=', request.url + '/')
end

get '/api/:book/:chapter' do
  content_type :json
  js_file = params[:book] + '/' + params[:book] + '_'+ params[:chapter] +'.js'
  file = File.read( File.join(settings.public_folder, js_file) )
  file
end

get '/api/:book/:chapter/:verse' do
  content_type :json
  js_file = params[:book] + '/' + params[:book] + '_'+ params[:chapter] +'.js'
  file = File.read( File.join(settings.public_folder, js_file) )
  verse = params[:verse].to_i - 1;
  JSON.parse(file)['response'][verse].to_json
end

# Error Handling
not_found do
  content_type :json
  { 'error' => 'Not Found' }.to_json
end
