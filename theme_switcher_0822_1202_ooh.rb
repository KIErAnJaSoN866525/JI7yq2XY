# 代码生成时间: 2025-08-22 12:02:18
# 主题切换应用
class ThemeSwitcher < Sinatra::Base

  # 设置主题的路由
  get '/theme' do
    # 获取请求中的参数
    theme = params['theme']
    # 检查主题是否有效
    if theme && ['dark', 'light'].include?(theme)
      # 将主题保存到会话中
      session[:theme] = theme
      # 返回成功信息
      "Theme switched to #{theme}."
    else
      # 如果主题无效，返回错误信息
      'Invalid theme. Please choose either dark or light.'
    end
  end

  # 主页路由，根据主题显示不同页面
  get '/' do
    # 获取当前主题，如果没有设置，则默认为'light'
    theme = session[:theme] || 'light'
    # 根据主题返回不同页面
    if theme == 'dark'
      "Welcome to the dark themed page."
    else
      "Welcome to the light themed page."
    end
  end

end

# 运行Sinatra应用
run! if app_file == $0