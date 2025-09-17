# 代码生成时间: 2025-09-18 01:34:41
# This Sinatra application demonstrates basic XSS protection.
# It's a simple web app that renders an HTML form and echoes back the input.
# The Rack::Protection::XSS middleware is used to sanitize user inputs to prevent XSS attacks.
class XssProtectionApp < Sinatra::Base

  # Use Rack::Protection::XSS to sanitize inputs
  use Rack::Protection::XSS

  # Home page that displays a simple form
  get '/' do
    "<html><body>
      <form action='/echo' method='post'>
        Enter text: <input type='text' name='user_input' />
        <input type='submit' value='Submit' />
      </form>
    </body></html>"
  end

  # Echoes back the user input, sanitized to prevent XSS
  post '/echo' do
    user_input = params['user_input']
    # Sanitize the input to prevent XSS
    # Rack::Protection::XSS does this automatically for us
    "<html><body>You entered: #{user_input}</body></html>"
  end

  # Error handling for any unexpected errors
  error do
    e = request.env['sinatra.error']
    "<html><body>Internal Server Error: #{e.message}</body></html>"
  end

end

# Run the Sinatra application
run XssProtectionApp if __FILE__ == $0