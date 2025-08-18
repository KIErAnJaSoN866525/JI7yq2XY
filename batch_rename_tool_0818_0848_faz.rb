# 代码生成时间: 2025-08-18 08:48:36
# Batch Rename Tool
# This Sinatra application allows users to rename multiple files in a directory.

# The main route for the application, where users can upload files and rename them.
get '/' do
  erb :index
end

# Route to handle file upload and renaming
post '/rename' do
  # Check if the request has a file
  if params[:file]
    file = params[:file][:tempfile]
    new_name = params[:new_name]
    
    # Error handling for file renaming
    begin
      # Ensure the new name does not exist and is valid
      if File.exist?(new_name)
        return "File with new name already exists."
      end
      
      # Move and rename the file
      FileUtils.mv(file.path, new_name)
      return "File successfully renamed to #{new_name}."
    rescue => e
      # Return the error message if an exception occurs
      return "An error occurred: #{e.message}"
    end
  else
    # If no file is uploaded, return an error message
    return "No file selected for renaming."
  end
end

__END__

@@ index
<!DOCTYPE html>
<html>
<head>
  <title>Batch Rename Tool</title>
</head>
<body>
  <h1>Batch Rename Tool</h1>
  <form action="/rename" method="post" enctype="multipart/form-data">
    <label for="file">Select file to rename:</label>
    <input type="file" name="file" id="file">
    <br>
    <label for="new_name">New file name:</label>
    <input type="text" name="new_name" id="new_name" required>
    <br>
    <button type="submit">Rename</button>
  </form>
</body>
</html>