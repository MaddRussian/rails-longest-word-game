require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @word = params["word"]
    url = "https://dictionary.lewagon.com/#{@word}"
    user_serialized = URI.parse(url).read
    user = JSON.parse(user_serialized)
    is_valid = true
    @word.chars.each do |letter|
      is_valid = false unless params[:letters].split('').include?(letter)
    end
    if user["found"] && is_valid
      @result = "Congratulations! #{@word} is a valid word!"
    elsif user["found"] && !is_valid
      @result = "Sorry, but #{@word} can't be built out of #{params[:letters]}."
    else
      @result = "Sorry, but #{@word} doesn't seem to be a valid English word"
    end
  end
end
