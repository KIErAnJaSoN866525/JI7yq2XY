# 代码生成时间: 2025-09-04 06:29:59
# 连接数据库
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'app.db')

# 定义User模型
class User < ActiveRecord::Base
  has_secure_password
end

# 创建User表
ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :username
    t.string :password_digest
  end
end

# Sinatra应用
class App < Sinatra::Base

  # 错误处理
  error do
    status 500
    {
        error: "Internal Server Error"
    }.to_json
  end

  # 首页
  get '/' do
    "Welcome to the SQL Injection Protection App!"
  end

  # 用户注册
  post '/register' do
    content_type :json
    params = JSON.parse(request.body.read)
    username = params['username']
    password = params['password']

    # 错误处理：用户名或密码为空
    if username.empty? || password.empty?
      status 400
      {
          error: "Username and password cannot be empty"
      }.to_json
      return
    end

    begin
      # 使用安全的密码哈希存储密码
      user = User.new(username: username, password: password)
      user.save
      status 200
      {
          message: "User registered successfully"
      }.to_json
    rescue ActiveRecord::RecordInvalid => e
      status 400
      {"error": e.message}.to_json
    end
  end

  # 用户登录
  post '/login' do
    content_type :json
    params = JSON.parse(request.body.read)
    username = params['username']
    password = params['password']

    # 错误处理：用户名或密码为空
    if username.empty? || password.empty?
      status 400
      {
          error: "Username and password cannot be empty"
      }.to_json
      return
    end

    user = User.find_by(username: username)

    if user && user.authenticate(password)
      status 200
      {"message": "Login successful"}.to_json
    else
      status 401
      {"error": "Invalid username or password"}.to_json
    end
  end
end

# 运行Sinatra应用
run! if app_file == $0