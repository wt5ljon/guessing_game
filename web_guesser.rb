require 'sinatra'
require 'sinatra/reloader'

class Guessing_game
	attr_accessor :guess, :secret_number, :color, :message, :remaining

	def initialize
		@color = "white"
		@message = ""
		@secret_number = -1
		@remaining = 5
	end

	def get_secret_number
		@secret_number = rand(100)
	end

	def check_guess
		if @secret_number < @guess.to_i
			@remaining -= 1
			if @secret_number < (@guess.to_i - 5)
				@message = "Way too high ... Guess again!"
				@color = "red"
			else
				@message = "Too high ... Guess again!"
				@color = "orchid"
			end
		elsif @secret_number > @guess.to_i
			@remaining -= 1
			if @secret_number > @guess.to_i + 5
				@message = "Way too low ... Guess again!"
				@color = "red"
			else
				@message = "Too low ... Guess again!"
				@color = "orchid"
			end
		else
			@message = "You got it right ... starting new game!"
			@color = "green"
			self.get_secret_number
			@remaining = 5
		end
	end
end

game = Guessing_game.new
game.get_secret_number
get '/' do
	game.guess = params['guess']
	if game.guess == nil
		erb :index, :locals => {:number => game.secret_number, 
			  :message => "", :color => "white", :guesses_left => "", 
				:last => "", :cheat => ""}
	else
		game.check_guess
		last_guess = "Last guess: #{game.guess}"
		if game.remaining == 0
			game.message = "You lose! SECRET NUMBER: #{game.secret_number} ... starting new game"
			game.get_secret_number
			game.remaining = 5
			guesses_left_message = "You have #{game.remaining} guesses remaining"
			erb :index, :locals => {:number => game.secret_number, 
					:message => game.message, :color => "white", 
					:guesses_left => guesses_left_message, :last => last_guess,
					:cheat => ""}
		else
			guesses_left_message = "You have #{game.remaining} guesses remaining"
			if params['cheat'] == "true"
				erb :index, :locals => {:number => game.secret_number, 
						:message => game.message, :color => game.color, 
						:guesses_left => guesses_left_message, :last => last_guess,
						:cheat => "The SECRET NUMBER: #{game.secret_number}"}
			else
				erb :index, :locals => {:number => game.secret_number, 
						:message => game.message, :color => game.color, 
						:guesses_left => guesses_left_message, :last => last_guess,
						:cheat => ""}
			end
		end
	end
end

