# 代码生成时间: 2025-08-06 22:48:14
# 配置文件管理器
class ConfigManager
  # 初始化配置文件路径
  def initialize
    @config_path = './config.yml'
  end

  # 读取配置文件
  def read_config
    begin
      config = YAML.load_file(@config_path)
    rescue Errno::ENOENT
      return { error: 'Config file not found' }
    rescue Psych::SyntaxError
      return { error: 'Invalid YAML syntax' }
    end
    config
  end

  # 更新配置文件
  def update_config(new_config)
    begin
      File.open(@config_path, 'w') do |file|
        file.write(new_config.to_yaml)
      end
    rescue StandardError => e
      return { error: e.message }
    end
    { success: 'Configuration updated successfully' }
  end
end

# Sinatra 应用
class ConfigManagerApp < Sinatra::Base
  set :root, File.dirname(__FILE__)

  # 获取当前配置
  get '/config' do
    config_manager = ConfigManager.new
    config = config_manager.read_config
    if config.key?(:error)
      status 404
      { error: config[:error] }.to_json
    else
      config.to_json
    end
  end

  # 更新配置
  put '/config' do
    content_type :json
    params = JSON.parse(request.body.read)
    config_manager = ConfigManager.new
    result = config_manager.update_config(params)
    if result.key?(:error)
      status 400
      result.to_json
    else
      status 200
      result.to_json
    end
  end
end

# 启动 Sinatra 应用
run ConfigManagerApp