# 代码生成时间: 2025-08-30 23:53:23
# 定义一个简单的 Sinatra 应用
class MyApp < Sinatra::Base
  get '/' do"Hello, World!"end
end

# 使用 RSpec 进行单元测试
RSpec.describe 'MyApp' do
  include Rack::Test::Methods

  def app
    MyApp
  end

  # 测试根路径
  it 'responds with a success status' do
    get '/'
    expect(last_response.status).to eq(200)
  end

  # 测试根路径返回的文本
  it 'returns the correct text' do
    get '/'
    expect(last_response.body).to eq("Hello, World!")
  end
end

# 注释：
# 1. 我们首先导入了 Sinatra 和 RSpec 框架。
# 2. 定义了一个简单的 Sinatra 应用，其中包含了一个 GET 请求的处理。
# 3. 在 RSpec 描述块中，我们包含了 Rack::Test::Methods，这使我们能够在测试中使用 HTTP 请求。
# 4. 定义了一个 app 方法，它返回我们的 Sinatra 应用实例。
# 5. 我们编写了两个测试，一个检查根路径的响应状态码，另一个检查返回的文本内容。
# 6. 通过使用 expect 方法，我们能够断言响应应该符合预期。