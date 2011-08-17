# Wordlick
# Hangman solver
# Sinatra app controller
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
  @suggest = Wordlicker.suggest_letter @results, (@find.gsub('-', '') << @except)
  @suggestion = "<p>Try the letter #{@suggest.upcase} next.</p>" if @suggest
  #@debug   = Wordlicker.debug
  erb :layout
end

get '/build' do
  @letters = CGI.unescape env['rack.request.query_hash']['letters']
  @results = Wordlicker.build_words @letters
  #@debug  = Wordlicker.debug
  erb :layout
end