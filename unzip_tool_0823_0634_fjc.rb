# 代码生成时间: 2025-08-23 06:34:18
# Unzip Tool Sinatra Application
# This application provides a simple interface to unzip files.

class UnzipTool < Sinatra::Application
  # GET endpoint to display the form for file upload
  get '/' do
    erb :index
  end

  # POST endpoint to handle file upload and unzip
  post '/' do
    # Check if the uploaded file is present
    if params[:file]
      # Get the uploaded file
      file = params[:file][:tempfile]
      # Define the file name for the uploaded file
      file_name = params[:file][:filename]
      # Define the directory to store the unzipped files
      unzip_dir = 'unzipped_files'
      # Create the directory if it does not exist
      Dir.mkdir(unzip_dir) unless Dir.exist?(unzip_dir)
      
      # Begin unzipping the file
      begin
        # Unzip the file into the specified directory
        Zip::File.open(file) do |zip_file|
          zip_file.each do |entry|
            # Extract each file to the directory
            entry.extract(File.join(unzip_dir, entry.name))
          end
        end
        # Inform the user that the file has been successfully unzipped
        "File '#{file_name}' has been successfully unzipped into '#{unzip_dir}'"
      rescue Zip::Error => e
        # Handle any errors that occur during unzipping
        "An error occurred while unzipping the file: #{e.message}"
      end
    else
      # Inform the user that no file was uploaded
      "No file was uploaded."
    end
  end
end

# Helper method to serve the index page
get '/*' do
  'File not found.'
end

__END__

@@ index
<!DOCTYPE html>
<html>
<head>
  <title>Unzip Tool</title>
</head>
<body>
  <h1>Unzip Tool</h1>
  <form action='/' method='post' enctype='multipart/form-data'>
    <input type='file' name='file'>
    <input type='submit' value='Unzip File'>
  </form>
</body>
</html>