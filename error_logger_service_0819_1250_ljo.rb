# 代码生成时间: 2025-08-19 12:50:36
# ErrorLoggerService is a Sinatra application for collecting error logs.
class ErrorLoggerService < Sinatra::Base

  # Configure the logger instance to be used throughout the application.
  configure do
    enable :logging
    # Set the logging level to :error to collect only error logs.
    use Rack::CommonLogger, Logger.new($stderr, level: Logger::ERROR)
  end

  # Endpoint to receive error logs.
  # It expects a POST request with a JSON payload containing the error details.
  post '/log_error' do
    # Parse the JSON payload to a Ruby hash.
    error_data = JSON.parse(request.body.read)

    # Check if the payload has the required 'error_message' key.
    if error_data['error_message']
      # Log the error message to the configured logger.
      logger.error(error_data['error_message'])
      # Respond with a success message.
      { message: 'Error logged successfully.' }.to_json
    else
      # Respond with an error if the payload is missing the required key.
      { error: 'Missing error_message in payload.' }.to_json
    end
  end

  # Add a route to display the application version.
  get '/version' do
    "Error Logger Service v1.0"
  end

end

# Run the application if it's the main file being executed.
run! if app_file == $0