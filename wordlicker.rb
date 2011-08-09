# Wordlick
# hangman solver model
# (c) 2011 Diego Salazar

class Wordlicker
  LETTERS = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  WORDS   = File.read('words').split("\n") # copied this file from the ENABLE dictionary
  
  class << self
    # setup a regex to match the letters given in @find while omiting letters in @except
    # there can also not be more instances of the known letters present in the word in @find
    def get_solush(find, except)
      @find, @except = find, except
      solve!
    end
    
    def debug
      require 'pp'
      { :regexp => @regexp, :matchers => matchers, :rgxcept => @rgxcept }
    end
    
    private
    
    def solve!
      @regexp  = /^#{matchers}$/i
      @rgxcept = /#{@except.split('').join '|'}/i if @except && @except != ''
      @results = WORDS.select { |word| @regexp.match word }
      @results.reject! { |word| @rgxcept.match word } if @rgxcept
      @results
    end
    
    # match a known letter, or an unknown letter while excluding known letters
    def matchers
      @find.split('').map { |char| char == '?' ? allowed_letters : "#{char}{1}" }
    end
    
    # builds a regex: /[abdef...]{1}/ that excludes known letters
    def allowed_letters
      @allowed_letters ||= "[#{LETTERS.reject { |letter| @find.split('?').include? letter }}]{1}"
    end
    
  end
end