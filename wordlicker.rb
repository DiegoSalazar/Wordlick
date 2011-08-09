# Wordlick
# hangman solver model
# (c) 2011 Diego Salazar

class Wordlicker
  LETTERS = ('a'..'z').map
  WORDS   = File.read('./words').split("\n") # copied this file from the ENABLE dictionary
  
  class << self
    # setup a regex to match the letters given in @find while omiting letters in @except
    # there can also not be more instances of the known letters present in the word in @find
    def get_solush(find, except)
      @find, @except = find, except
      solve!
    end
    
    def debug
      require 'pp'
      { :regexp => @regexp, :rgxcept => @rgxcept }
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
      @find.split('').map { |char| char == '*' ? allowed_letters : "#{char}{1}" }.join ''
    end
    
    # builds a regex: /[abdef...]{1}/ that excludes known letters
    def allowed_letters
      @allowed_letters ||= "[#{LETTERS.reject { |letter| @find.split('*').include? letter }.join ''}]{1}"
    end
    
  end
end