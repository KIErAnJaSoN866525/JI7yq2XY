# 代码生成时间: 2025-08-11 21:51:34
# Simple in-memory user store for demonstration purposes.
# In a real-world scenario, this would be replaced with a database.
USERS = {
  "user1" => "password1",
  "user2" => "password2"
}

# This is the main application class.
class LoginSystem < Sinatra::Base
  # POST endpoint for user login.
  post '/login' do
    # Parse JSON payload to get username and password.
    params = JSON.parse(request.body.read)
    username = params['username']
    password = params['password']
    
    # Check if username and password are provided.
    if username.nil? || password.nil?
      return json_response(400, 'Missing username or password.')
    end
    
    # Check if the user exists and the password is correct.
    if USERS[username] == password
      return json_response(200, 'Login successful.')
    else
      return json_response(401, 'Invalid username or password.')
    end
  end

  # Helper method to send JSON responses.
  def json_response(status, message)
    content_type :json
    { status: status, message: message }.to_json
  end
end

# Set the Sinatra application to run on port 4567.
set :port, 4567

# Start the Sinatra server.
run! if app_file == $0