# 代码生成时间: 2025-08-03 01:41:14
# ThemeSwitcher is a simple Sinatra application that allows users to switch between themes.
class ThemeSwitcher < Sinatra::Application
  # Set the default theme
  enable :sessions
  get '/' do
    # If no theme is set in the session, default to 'light'
    session[:theme] ||= 'light'
    "Current theme is #{session[:theme]}"
  end

  # Route to switch themes
  get '/switch_theme' do
    # Check if a theme is provided in the query string
    if params['theme']
      # Validate the theme to be either 'light' or 'dark'
      theme = params['theme'].to_s.strip
      if theme == 'light' || theme == 'dark'
        session[:theme] = theme
        "Theme switched to #{theme}"
      else
        # Return an error if the theme is not valid
        'Invalid theme'
      end
    else
      # Return an error if no theme is provided
      'No theme provided'
    end
  end
end