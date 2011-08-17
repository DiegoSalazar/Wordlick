# Wordlicker
# Hangman solver/builder singleton

class Wordlicker
  LETTERS = ('a'..'z').map
  WORDS   = File.read('./words').split("\n") # copied this file from the ENABLE dictionary
  # found these on http://osxreality.com/2010/01/01/beginners-guide-to-words-with-friends-2/
  LETTER_VALUES = {
    'A' => 1, 'B' => 4,	'C' => 4,	'D' => 2, 'E' => 1, 'F' => 4,	'G' => 3, 'H' => 3, 'I' => 1,
    'J' => 10,'K' => 5, 'L' => 2, 'M' => 4,	'N' => 2, 'O' => 1, 'P' => 4, 'Q' => 10,'R' => 1,
    'S' => 1, 'T' => 1, 'U' => 2, 'V' => 5, 'W' => 4, 'X' => 8, 'Y' => 3, 'Z' => 10
  }
  
  class << self
    # setup a regex to match the letters given in @find while omiting letters in @except
    # there can also not be more instances of the known letters present in the word in @find
    def get_solush(find, except)
      @find, @except = find, except
      solve!
    end
    
    # suggest next letter to try based on the number of non-unique letters
    # go through each word and count up the letters not in @tryed
    # the most common letter should be suggested
    def suggest_letter(words, tryed)
      @words, @tryed = [words].flatten, tryed
      suggest!
    end
    
    # takes a set of 12 letters and finds all words that contain these letters
    # then scores the words according to their letter values and sorts them in descending order
    def build_words(letters)
      @letters = letters
      build!
    end
    
    def debug
      require 'pp'
      @debug = {}
      instance_variables.each do |var|
        @debug.store var.sub('@', ''), instance_variable_get(var) unless var == '@debug'
      end
      @debug
    end
    
    private
    
    def solve!
      @regexp = /^#{matchers}$/i
      find_words
      reject_words @find
      @total = @results.size
      @results
    end
    
    def build!
      # TODO: improve this regexp
      letter_arr = @letters.split('')
      @regexp = /#{letter_arr.map { |l| "#{l}{1,#{@letters.scan(l).size}}" }.join '|'}/i
      @except = LETTERS.reject { |letter| letter_arr.include? letter }.join
      find_words
      reject_words @letters
      score_words
      @results = @scores
      @total   = @results.size
      @results.shift(20).map! { |r| [r[:word], r[:score]] } # first 20 results
    end
    
    def suggest!
      @counts = {}
      @words.each do |word|
        word.split('').each do |letter|
          unless @tryed[letter]
            @counts[letter] ||= 0
            @counts[letter] += 1
          end
        end
      end
      @suggestion = @counts.sort { |a, b| a.last <=> b.last }.reverse.first[0]
    end
    
    def find_words
      words = WORDS.select { |word| word.size.between? 4, 8 }
      @results = words.select { |word| @regexp.match word }
    end
    
    def reject_words(letters)
      return unless @except && @except != ''
      @rgxcept = /#{@except.split('').join '|'}/i
      @results.reject! { |word| @rgxcept.match word }
      letter_arr = letters.split('')
      # we need to do some further rejections based on the number of non-unique letters
      # if we have 2 "e" in the set, we can't allow words that have more than 2 "e"
      @results.reject! do |word|
        letter_arr.any? do |letter|
          next if word[letter].nil?
          num_in_word = word.scan(letter).size
          num_in_set  = letters.scan(letter).size
          num_in_word > num_in_set
        end
      end
    end
    
    # match a known letter, or an unknown letter while excluding known letters
    def matchers
      @find.split('').map { |char| char == '-' ? allowed_letters : "#{char}{1}" }.join ''
    end
    
    # builds a regex: /[abdef...]{1}/ that excludes known letters
    def allowed_letters
      @allowed_letters ||= "[#{LETTERS.reject { |letter| (@find.split('*') | @except.split('')).include?(letter) }.join ''}]{1}"
    end
    
    # score words and sort in descending order
    def score_words
      @scores = @results.map do |word|
        { :word => word, :score => score_word(word) }
      end.sort { |a, b| a[:score] <=> b[:score] }.reverse
    end
    
    def score_word(word)
      points  = word.split('').map { |letter| LETTER_VALUES[letter.upcase] }
      # get the sum of all ints in array. inject is awesome!
      points.inject(0) { |result, num| result += num }
    end
    
  end
end