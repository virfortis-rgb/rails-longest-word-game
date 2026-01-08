require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    extra_vowels = ['A', 'E', 'I', 'O', 'U', 'A', 'E', 'I', 'O', 'U']
    @letters = alphabet.push(extra_vowels.flatten!).sample(10)
  end

  def score
    word = params[:answer].upcase
    url = "https://dictionary.lewagon.com/#{word}"
    input_serialized = URI.open(url).read
    input = JSON.parse(input_serialized)

    if input["found"] == false
      @score = "Invalid Word! #{word.capitalize} is not an English word."
    elsif word.chars.size == 0
      @score = "Please try again. You didn't enter anything!"
    elsif does_match?(word, params[:letters].split(" ")) == true
      @score = "Congrats! You did it! You made a word!"
    else
      @score = "Oh no! #{word.upcase} cannot be made out of #{params[:letters].split(" ").each { |letter| letter}}."
    end
  end
end

def does_match?(word, letters)
  split_word = word.chars
  result = true
  split_word.each do |w|
    if letters.include?(w)
      letters.delete_at(letters.index(w))
    else
      result = false
    end
  end
  result
end
