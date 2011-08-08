# Hangman solver
# (c) 2011 Diego Salazar
require 'rubygems'
require 'sinatra'

get '/' do
  erb :layout
end

post '/' do
  letters = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  words  = File.read('./words').split "\n"
  params = env['rack.request.form_hash']
  @find, @except = params['find'], params['except']
  
  any_letter = lambda { |ex| ex ? "[#{letters.reject { |l| ex.include? l }.join ''}]{1}" : '[a-z]{1}'  }
  regex      = /^(#{@find.split('').map { |f| f == '?' ? any_letter.call(@find.split('?').reject { |l| l == '' }) : f }.join ''})$/i
  
  @results = words.select { |w| w.match(regex) }
  @results.reject! { |w| /#{@except}/i.match(w) } if @except && @except != ''
  
  erb :layout
end