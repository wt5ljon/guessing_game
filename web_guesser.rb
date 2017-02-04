require 'sinatra'
require 'sinatra/reloader'

def check_guess(guess, number)
	if number < guess
		if number < guess - 5
			result = "Way too high!"
			color = "red"
		else
			result = "Too high!"
			color = "orchid"
		end
	elsif number > guess
		if number > guess + 5
			result = "Way too low!"
			color = "red"
		else
			result = "Too low!"
			color = "orchid"
		end
	else
		result = "You got it right!"
		color = "green"
	end
	return result, color
end

number = rand(100)
message = ""
get '/' do
	guess = params['guess']
	message, color = check_guess(guess.to_i, number)
	erb :index, :locals => {:number => number, :message => message, :color => color}
end

