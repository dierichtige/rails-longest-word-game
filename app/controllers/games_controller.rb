require "json"
require "open-uri"

class GamesController < ApplicationController

  def new
    @letters = []
    (1..10).each do |_num|
      random = ('A'..'Z').to_a.sample
      @letters.push(random)
    end
    return @letters
  end

  def score
    input = params[:word] # this is a string
    letters = params[:letters]  # params[:letters] become a string separated by a space in b/w, dunno why
    url = "https://wagon-dictionary.herokuapp.com/#{input}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    found = user["found"]
    input_arr = input.upcase.split(//) # cast @input into an array (all uppercase)
    letters_arr = letters.split(" ") # cast letters into an array (all uppercase)
    # letters_arr = ['S', 'T', 'I', 'U', 'N', 'P', 'Z', 'B', 'Q', 'N']
    i = 0
    if found
      input_arr.each do |ip|
        unless letters_arr.index(ip).nil?
          letters_arr.delete_at(letters_arr.index(ip))
          i += 1
        end
      end
      if i <= letters_arr.count && i == input_arr.count
        @first_seg = "Congratulations!"
        @first_class = "bold"
        @second_seg = "#{input.upcase}"
        @second_class = ""
        @third_seg = "is a valid English word!"
      else
        # @result = "Sorry but #{input.upcase} can't be built out of #{letters.split(" ").join(", ")}"
        @first_seg = "Sorry but"
        @first_class = ""
        @second_seg = "#{input.upcase}"
        @second_class = "bold"
        @third_seg = "can't be built out of #{letters.split(" ").join(", ")}"
      end
    else
      # @result = "Sorry but #{input.upcase} does not seem to be a valid English word..."
      @first_seg = "Sorry but"
      @first_class = ""
      @second_seg = "#{input.upcase}"
      @second_class = "bold"
      @third_seg = "does not seem to be a valid English word..."
    end
    # raise
  end
end
