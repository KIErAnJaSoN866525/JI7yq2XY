# 代码生成时间: 2025-08-08 16:03:43
# 系统性能监控工具
class PerformanceMonitor < Sinatra::Base

  # 定义路由，返回系统性能信息
  get '/performance' do
    # 获取系统性能数据
    system_performance = get_system_performance
    # 返回JSON格式的性能数据
    json_performance = {
      :cpu_usage => system_performance[:cpu_usage],
      :memory_usage => system_performance[:memory_usage],
      :disk_usage => system_performance[:disk_usage]
    }
    content_type :json
    json_performance.to_json
  end

  private

  # 获取系统性能数据
  # @return [Hash] 包含CPU、内存和磁盘使用情况的哈希表
  def get_system_performance
    # CPU使用率
    cpu_usage = get_cpu_usage
    # 内存使用率
    memory_usage = get_memory_usage
    # 磁盘使用率
    disk_usage = get_disk_usage
    {
      :cpu_usage => cpu_usage,
      :memory_usage => memory_usage,
      :disk_usage => disk_usage
    }
  end

  # 获取CPU使用率
  # @return [Float] CPU使用率
  def get_cpu_usage
    io, _, _ = Open3.capture3('top -bn1 | grep "Cpu(s)"')
    io.scan(/load average: ([0-9.]+)/).flatten.first.to_f
  end

  # 获取内存使用率
  # @return [Float] 内存使用率
  def get_memory_usage
    io, _, _ = Open3.capture3('free -m')
    memory_total, memory_used = io.lines[1].split[1..2].map(&:to_i)
    (memory_used.to_f / memory_total) * 100
  end

  # 获取磁盘使用率
  # @return [Float] 磁盘使用率
  def get_disk_usage
    io, _, _ = Open3.capture3('df -h /')
    disk_usage = io.lines[1].split[4]
    disk_usage.gsub('%', '').to_f
  end

  not_found do
    '404 Not Found'
  end

  error do
    '500 Internal Server Error'
  end
end

# 运行Sinatra应用
run! if __FILE__ == $0