# Wordlick
# hangman solver
# (c) 2011 Diego Salazar

require 'rubygems'
require 'sinatra'

get '/' do
  erb :layout
end

post '/' do
  letters, words = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z), File.read('./words').split("\n")
  @find, @except = env['rack.request.form_hash']['find'], env['rack.request.form_hash']['except']
  known_letters  = @find.split '?'
  finder_without_known = "[#{letters.reject { |l| known_letters.include? l }}]{1}"
  
  # setup a regex to match the letters given in @find while omiting letters in @except
  # there can also not be more instances of the known letters present in the word in @find
  matchers = @find.split('').map do |f|
    f == '?' ? finder_without_known : "#{f}{1}"
  end
  regexp  = /^#{matchers}$/i
  rgxcept = /#{@except.split('').join '|'}/i if @except && @except != ''
  
  @results = words.select { |w| regexp.match w }
  @results.reject! { |w| rgxcept.match w } if rgxcept
  
  if false # debugging
    require 'pp'
    @debug = { :regexp => regexp, :matchers => matchers, :rgxcept => rgxcept }
  end
  
  erb :layout
end