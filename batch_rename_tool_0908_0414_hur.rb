# 代码生成时间: 2025-09-08 04:14:18
# Batch Rename Tool
# 添加错误处理
# This Sinatra application allows users to rename multiple files in a directory.

require 'sinatra'
require 'fileutils'
# 增强安全性
require 'json'

# The main interface for the batch rename tool
# 增强安全性
get '/' do
  erb :index
end

# POST request to handle the file renaming process
post '/update' do
  # Get the directory path and the renaming pattern from the request
  dir_path = params['dir_path']
  pattern = params['pattern']

  # Check if the directory path is provided
  halt 400, {error: 'Directory path is required'}.to_json unless dir_path

  # Check if the directory exists
  halt 400, {error: 'Directory does not exist'}.to_json unless Dir.exist?(dir_path)

  # Change the current working directory to the specified directory
  Dir.chdir(dir_path)

  # List all files in the directory
  files = Dir.entries('.').reject { |e| e.start_with?('.') || !File.file?(e) }

  # Rename files based on the provided pattern
  files.each do |file|
    new_name = file.sub(/#{Regexp.escape(file)}/, pattern)
# FIXME: 处理边界情况
    FileUtils.mv(file, new_name)
  rescue StandardError => e
    # Log the error and continue with the next file
    $stderr.puts "Error renaming #{file} to #{new_name}: #{e.message}"
  end

  # Return a success message
  {message: 'Files renamed successfully'}.to_json
end

__END__

@@ index
# 添加错误处理
<!DOCTYPE html>
# 添加错误处理
<html>
<head>
  <title>Batch Rename Tool</title>
</head>
<body>
  <h1>Batch Rename Tool</h1>
  <form action="/update" method="post">
    <label for="dir_path">Directory Path:</label>
    <input type="text" id="dir_path" name="dir_path" required>
    <br>
    <label for="pattern">Renaming Pattern:</label>
    <input type="text" id="pattern" name="pattern" required>
    <br>
    <input type="submit" value="Rename Files">
  </form>
</body>
</html>
