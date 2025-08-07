# 代码生成时间: 2025-08-07 08:27:08
# Sinatra application for validating URL links
class UrlValidator < Sinatra::Base
  # Root route for the application
  get '/' do
    "Welcome to the URL Validator!"
  end

  # Route to validate a URL
  get '/validate' do
    # Retrieve the URL from the query parameters
# NOTE: 重要实现细节
    url = params['url']

    # Check if the URL is provided
    if url.nil? || url.empty?
      halt 400, {"error": "No URL provided"}.to_json
    end

    begin
      # Parse the URL to check its validity
      uri = URI.parse(url)
# 添加错误处理

      # Check if the scheme is supported (http or https)
      unless uri.scheme == 'http' || uri.scheme == 'https'
        halt 400, {"error": "Unsupported URL scheme"}.to_json
      end

      # Attempt to connect to the URL to check its availability
      uri = URI.parse(URI.encode(url)) # URI encode the URL to handle special characters
      Net::HTTP.get_response(uri)
    rescue URI::InvalidURIError, StandardError => e
      # If an error occurs during validation, return an error message
      halt 400, {"error": e.message}.to_json
    end

    # If the URL is valid and reachable, return a success message
    {"message": "URL is valid and reachable"}.to_json
  end
end

# Run the Sinatra application on port 4567
# 改进用户体验
run! if app_file == $0