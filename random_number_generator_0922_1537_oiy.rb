# 代码生成时间: 2025-09-22 15:37:39
# RandomNumberGeneratorApp is a Sinatra-based web application
# that provides an endpoint to generate random numbers.
class RandomNumberGeneratorApp < Sinatra::Base

  # The root path '/' responds with a simple HTML form to generate random numbers.
  get '/' do
    erb :index
  end

  # POST '/generate' endpoint that handles the form submission and generates a random number.
  post '/generate' do
    # Error handling for missing or invalid parameters.
    min = params[:min].to_i
    max = params[:max].to_i
    if min.nil? || max.nil? || min < 0 || max < 0 || min >= max
      status 400
      return {
        error: "Invalid input: 'min' and 'max' must be provided and 'min' < 'max'.",
      }.to_json
    end

    # Generate a random number between the provided range.
    random_number = rand(min..max)
    {
      random_number: random_number,
    }.to_json
  end

  # Helper method to render the index view.
  get '/view/:index.html' do
    erb File.read("./views/#{params[:index]}.erb")
  end

  # Default error handling for Sinatra.
  not_found do
    "Sorry, we can't find that!"
  end

  # Error handling for other errors.
  error do
    e = request.env['sinatra.error']
    error_logger.error("Error: #{e.message}") if error_logger
    "An error occurred."
  end

end

# Set up the views folder for ERB templates.
set :views, File.dirname(__FILE__) + '/views'

# Start the server if the file is executed directly.
run! if app_file == $0