require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
    @letters
  end

  def score
    @answer = params[:word].upcase.chars
    @grid_letters = params[:grid].split(' ')
    user_serialised = URI.open("https://wagon-dictionary.herokuapp.com/#{params[:word]}").read
    user = JSON.parse(user_serialised)

    check = @answer.count do |c|
      @answer.count(c) > @grid_letters.count(c)
    end

    if (@answer - @grid_letters).empty? && user['found'] == true && check.zero?
      @result = 'Well Done!'
    elsif !check.zero?
      @result = 'Your word contains letters which is not in the grid'
    elsif user['found'] == false && (@answer - @grid_letters).empty? && check.zero?
      @result = 'This word does not exist'
    end
    @result
  end
end
