# 代码生成时间: 2025-09-22 13:14:39
# Test data generator application using Sinatra framework
class TestDataGenerator < Sinatra::Base

  # GET endpoint to generate a single test user
  get '/user' do
    # Generate a test user
    user = {
      name: "John Doe",
      email: "john.doe@example.com",
      age: 30
    }
    # Return JSON response
    content_type :json
    user.to_json
  end

  # GET endpoint to generate multiple test users
  get '/users/:count' do |count|
    # Validate count parameter
    count = Integer(count)
    if count <= 0
      status 400
      return "{"error": "Count must be a positive integer"}"
    end

    # Generate multiple test users
    users = Array.new(count) do |i|
      {
        name: "User#{i+1}",
        email: "user#{i+1}@example.com",
        age: 20 + rand(30) # Random age between 20 and 50
      }
    end

    # Return JSON response
    content_type :json
    users.to_json
  end

end

# Start the Sinatra server
run! if app_file == $0