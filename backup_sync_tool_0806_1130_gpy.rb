# 代码生成时间: 2025-08-06 11:30:44
# 文件备份和同步工具的Sinatra应用程序
class BackupSyncTool < Sinatra::Base

  # 根路径下的GET请求，提供一个简单的欢迎信息
  get '/' do
    "Welcome to the Backup & Sync Tool!"
  end

  # 备份文件的POST请求处理
  post '/backup' do
    # 从请求中获取文件路径和备份路径
    file_path = params['file_path']
    backup_path = params['backup_path']

    # 错误处理：检查文件路径和备份路径是否提供
    halt 400, "Missing file_path or backup_path parameter" unless file_path && backup_path

    # 确保文件存在
    unless File.exist?(file_path)
      halt 404, "File not found: #{file_path}"
    end

    # 创建备份目录（如果不存在）
    FileUtils.mkdir_p(File.dirname(backup_path))

    # 执行备份操作
    begin
      FileUtils.cp(file_path, backup_path)
      "Backup of #{file_path} created at #{backup_path}"
    rescue => e
      # 错误处理：备份失败
      halt 500, "Backup failed: #{e.message}"
    end
  end

  # 同步文件夹的POST请求处理
  post '/sync' do
    # 从请求中获取源文件夹路径和目标文件夹路径
    source_path = params['source_path']
    target_path = params['target_path']

    # 错误处理：检查源文件夹路径和目标文件夹路径是否提供
    halt 400, "Missing source_path or target_path parameter" unless source_path && target_path

    # 确保源文件夹和目标文件夹都存在
    unless Dir.exist?(source_path) && Dir.exist?(target_path)
      halt 404, "Source or target directory not found"
    end

    # 执行同步操作
    begin
      FileUtils.cp_r(File.join(source_path, '*'), target_path)
      "Sync from #{source_path} to #{target_path} completed"
    rescue => e
      # 错误处理：同步失败
      halt 500, "Sync failed: #{e.message}"
    end
  end

end

# 设置Sinatra应用程序运行在端口4567
set :port, 4567
run! if __FILE__ == $0
