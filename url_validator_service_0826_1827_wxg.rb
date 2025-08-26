# 代码生成时间: 2025-08-26 18:27:11
# 定义UrlValidatorService类
class UrlValidatorService
  attr_accessor :url

  # 初始化方法
  def initialize(url)
    @url = url
  end

  # 验证URL链接是否有效
  def validate
    # 使用URI类解析URL
    parsed_url = URI.parse(url)
    
    # 判断解析后的URL是否为HTTP或HTTPS协议
    unless parsed_url.is_a?(URI::HTTP) || parsed_url.is_a?(URI::HTTPS)
      return { valid: false, message: 'Unsupported URL scheme' }
    end

    # 使用Net::HTTP发送HEAD请求检查URL是否存在
    response = Net::HTTP.start(parsed_url.host, parsed_url.port) do |http|
      http.head(parsed_url.request_uri)
    end

    # 根据响应状态码判断URL是否有效
    if response.is_a?(Net::HTTPSuccess) || response.is_a?(Net::HTTPRedirection)
      { valid: true, message: 'URL is valid' }
    else
      { valid: false, message: 'URL is invalid' }
    end
  rescue => e
    # 捕获异常并返回错误信息
    { valid: false, message: 'Error validating URL: ' + e.message }
  end
end

# 定义Sinatra路由
get '/validate_url/:url' do
  content_type :json
  url = params[:url]
  result = UrlValidatorService.new(url).validate
  
  # 将结果返回为JSON格式
  result.to_json
end