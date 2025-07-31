# 代码生成时间: 2025-07-31 17:56:30
class SystemMonitorService < Sinatra::Base
  # 定义一个路由来获取系统性能信息
  get '/monitor' do
    # 获取系统信息
    system_info = get_system_info
    # 以JSON格式返回系统信息
    content_type :json
    system_info.to_json
  end

  private

  # 定义一个私有方法来获取系统信息
  def get_system_info
    begin
      # 这里只是一个示例，实际中可以使用系统命令或第三方库来收集系统性能数据
      system_info = {
        cpu_usage: `top -bn 1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/"`.strip,
        memory_usage: `free -m | awk 'NR==2{printf "%.2f%%", $3/$2 * 100}'`.strip,
        disk_usage: `df -h | grep -v Filesystem | awk '{ print $5 }'`.strip
      }
      # 确保返回的CPU和内存使用率是以百分比形式
      system_info[:cpu_usage] = system_info[:cpu_usage].to_f * 100 if system_info[:cpu_usage].match?(/\d/)
      system_info[:memory_usage] = system_info[:memory_usage].to_f * 100 if system_info[:memory_usage].match?(/\d/)
      system_info
    rescue => e
      # 错误处理，返回错误信息
      { error: e.message }
    end
  end
end

# 设置Sinatra监听的端口
set :port, 4567

# 运行Sinatra应用
run! if app_file == $0