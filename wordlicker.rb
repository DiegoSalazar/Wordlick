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
    
    # match a known letter, or an unknown letter but excluding known letters
    def matchers
      @find.split('').map { |char| char == '?' ? finder_without_known : "#{char}{1}" }
    end
    
    # builds a regex: /[abdef...]{1}/ that excludes known letters
    def finder_without_known
      allowed_letters = LETTERS.reject { |letter| known_letters.include? letter }
      "[#{allowed_letters}]{1}"
    end
    
    def known_letters
      @find.split '?'
    end
    
  end
end