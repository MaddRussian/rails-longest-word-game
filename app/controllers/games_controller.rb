require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
    @starting = Time.now
  end

  def score
    session[:score] = 0 unless session[:score]
    @ending = Time.now
    @current_score = 0
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
      if @ending - params[:starting].to_datetime < 5
        @current_score += (5 + @word.length)
      else
        @current_score += @word.length
      end
    elsif user["found"] && !is_valid
      @result = "Sorry, but #{@word} can't be built out of #{params[:letters]}."
    else
      @result = "Sorry, but #{@word} doesn't seem to be a valid English word"
    end
    session[:score] += @current_score
  end
end
