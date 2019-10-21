require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    # raise
    @result =
      (if wagon_dictionary?(params[:longest_word])
         if hashes?
           "Congratulations! #{params[:longest_word]} is a valid English word. Score: #{params[:longest_word].size}"
         else
           "Sorry but #{params[:longest_word]} can't be built out of #{params[:letters]}"
         end
       else
         "Sorry but #{params[:longest_word]} does not seem to be an English word"
       end)
  end

  def hashes?
    letters_hash = Hash.new(0)
    params_hash = Hash.new(0)
    params[:letters].split(',').each { |letter| letters_hash[letter] += 1 }
    params[:longest_word].split.each { |letter| params_hash[letter] += 1 }

    params[:longest_word].chars.all? { |letter| params_hash[letter] <= letters_hash[letter] }
  end

  def wagon_dictionary?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictornary = open(url).read
    dictonary_hash = JSON.parse(dictornary)
    dictonary_hash['found']
  end
end
