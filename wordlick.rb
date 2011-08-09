# Wordlick
# hangman solver controller
# (c) 2011 Diego Salazar

%w(rubygems sinatra cgi).map { |lib| require lib }
require './wordlicker'

get '/' do
  erb :layout
end

get '/solve' do
  @find    = CGI.unescape env['rack.request.query_hash']['find']
  @except  = CGI.unescape env['rack.request.query_hash']['except']
  @results = Wordlicker.get_solush @find, @except
  #@debug   = Wordlicker.debug
  erb :layout
end