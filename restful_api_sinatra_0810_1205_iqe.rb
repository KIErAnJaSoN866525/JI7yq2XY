# 代码生成时间: 2025-08-10 12:05:39
# 这是一个使用Ruby和Sinatra框架创建的RESTful API接口程序。
# 它遵循最佳实践，结构清晰，易于理解，并包含错误处理。

# 定义全局变量用于存储数据
DATA = []

# 获取所有数据的GET请求
get '/' do
  # 检查是否有数据
  if DATA.empty?
    # 如果没有数据，返回空数组和适当的状态码
    content_type :json
    {status: 'success', data: []}.to_json
  else
    # 如果有数据，返回数据和适当的状态码
    content_type :json
    {status: 'success', data: DATA}.to_json
  end
end

# 添加新数据的POST请求
post '/' do
  # 从请求体中解析JSON数据
  content_type :json
  data = JSON.parse(request.body.read)

  # 检查数据是否包含必要的属性
  unless data.include?(:name) && data.include?(:value)
    status 400
    {status: 'error', message: 'Missing name or value'}.to_json
  else
    # 添加新数据到全局变量
    DATA.push(data)
    {status: 'success', data: data}.to_json
  end
end

# 更新数据的PUT请求
put '/:id' do
  # 从路由参数中获取ID
  id = params[:id].to_i
  # 从请求体中解析JSON数据
  content_type :json
  data = JSON.parse(request.body.read)

  # 检查ID是否有效
  if id < 0 || id >= DATA.size
    status 404
    {status: 'error', message: 'Data not found'}.to_json
  else
    # 更新数据
    DATA[id] = data
    {status: 'success', data: DATA[id]}.to_json
  end
end

# 删除数据的DELETE请求
delete '/:id' do
  # 从路由参数中获取ID
  id = params[:id].to_i

  # 检查ID是否有效
  if id < 0 || id >= DATA.size
    status 404
    {status: 'error', message: 'Data not found'}.to_json
  else
    # 删除数据
    result = DATA.delete_at(id)
    {status: 'success', data: result}.to_json
  end
end