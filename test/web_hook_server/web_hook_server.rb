require 'rubygems'
require 'sinatra'

post '/' do
  puts params[:event]
end