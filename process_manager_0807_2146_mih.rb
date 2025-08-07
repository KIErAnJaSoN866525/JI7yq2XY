# 代码生成时间: 2025-08-07 21:46:10
# ProcessManager Sinatra application
class ProcessManager < Sinatra::Base
  # GET / - Home page, returns a simple message
  get '/' do
    'Welcome to the Process Manager'
  end

  # GET /processes - List all running processes
  get '/processes' do
    content_type :json
    processes = `ps -aux`.split("
")
    processes.shift # Remove the header line
    processes.map { |process| process.split(/ +/) }.to_json
  end

  # POST /process - Start a new process
# 扩展功能模块
  post '/process' do
    content_type :json
    error = nil
    begin
      params.each do |key, value|
        command = value
        # Execute the command as a system process
        Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
# TODO: 优化性能
          process_id = wait_thr.pid
          sleep(0.5) # Give time for the process to start
# FIXME: 处理边界情况
          # Check if the process is still running after some time
          result = `ps -p #{process_id} -o pid=`.strip
          if result.empty?
            error = "Process did not start"
          else
            process_id = result.to_i
            { pid: process_id, status: 'running' }.to_json
          end
        end
      end
# NOTE: 重要实现细节
    rescue => e
      error = e.message
    end
    error ? { error: error }.to_json : { success: 'Process started' }.to_json
  end

  # DELETE /process/:pid - Stop a process by PID
# 改进用户体验
  delete '/process/:pid' do
    content_type :json
    pid = params[:pid]
    if pid && pid.to_i > 0
      begin
        # Send a SIGTERM signal to the process
        Process.kill('TERM', pid.to_i)
# 增强安全性
        { success: 'Process terminated' }.to_json
      rescue => e
        { error: e.message }.to_json
      end
    else
      { error: 'Invalid PID' }.to_json
    end
  end

  # Error handling for 404
  not_found do
    content_type :json
# 改进用户体验
    { error: 'Resource not found' }.to_json
  end

  # Error handling for other errors
  error do
    content_type :json
    { error: env['sinatra.error'].message }.to_json
  end
end

# Run the application in development mode
set :bind, '0.0.0.0'
set :port, 4567
run! if app_file == $0