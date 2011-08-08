require 'rubygems'
require 'sinatra'

get '/' do
  erb :layout
end

post '/' do
  words  = File.read('./words').split "\n"
  params = env['rack.request.form_hash']
  @find, @except = params['find'], params['except']
  any_letter     = '[a-zA-Z]{1}'
  regex          = /^(#{@find.split('').map { |f| f == '?' ? any_letter : f }.join ''})$/
  
  @results = words.select { |w| w.match(regex) }
  @results = @results.reject { |w| /#{@except}/i.match(w) } if @except && @except != ''
  
  erb :layout
end