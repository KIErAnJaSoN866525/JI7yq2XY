# 代码生成时间: 2025-08-28 21:41:10
# Sinatra单元测试框架
# 代码结构清晰，易于理解，包含适当的错误处理，添加必要的注释和文档，遵循RUBY最佳实践，确保代码的可维护性和可扩展性

require 'sinatra'
require 'rspec'
require 'rack/test'

# 定义一个简单的Sinatra应用
class MyApp < Sinatra::Base
  get '/' do
    'Hello, World!'
  end
end

# 使用Rack::Test进行单元测试
RSpec.describe 'MyApp' do
  include Rack::Test::Methods

  def app
    MyApp
  end

  # 测试根路径
  describe 'GET /' do
    it 'responds with a 200 status code' do
      get '/'
      expect(last_response.status).to eq(200)
    end

    it 'returns the expected response' do
      get '/'
      expect(last_response.body).to eq('Hello, World!')
    end
  end
end