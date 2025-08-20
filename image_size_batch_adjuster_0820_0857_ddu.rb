# 代码生成时间: 2025-08-20 08:57:34
# Image Size Batch Adjuster
# A Sinatra application to resize multiple images.

class ImageSizeBatchAdjuster < Sinatra::Base

  # Route to receive the form data and uploaded images.
  # POST /resize
  post '/resize' do
    # Check if any image has been uploaded.
    if params[:images].nil? || params[:images].empty?
      error_response('No images have been uploaded.')
    end

    # Get the desired size from the form data.
    target_size = params[:size]
    if target_size.nil? || target_size.empty?
      error_response('No target size specified.')
    end

    # Create a directory to store resized images.
    resized_images_dir = './resized_images'
    Dir.mkdir(resized_images_dir) unless Dir.exist?(resized_images_dir)

    # Resize each uploaded image and save to the directory.
    resized_images_info = []
    params[:images].each do |image|
      begin
        # Create a filename for the resized image.
        filename = image[:filename]
        resized_filename = "#{resized_images_dir}/#{filename}"

        # Resize the image using MiniMagick.
        imagemagick = MiniMagick::Image.new(image[:tempfile].path)
        imagemagick.resize target_size
        imagemagick.write resized_filename

        # Add information about the resized image.
        resized_images_info << {
          'original_filename' => filename,
          'resized_filename' => resized_filename,
          'size' => target_size
        }
      rescue MiniMagick::Error => e
        # Handle image processing errors.
        error_response("Error resizing image #{filename}: #{e.message}")
      end
    end

    # Return the information about the resized images.
    json_response(resized_images_info)
  end

  # Helper method to return a JSON response.
  def json_response(data)
    content_type :json
    data.to_json
  end

  # Helper method to return an error response in JSON format.
  def error_response(message)
    content_type :json
    { error: message }.to_json
  end
end

# Run the Sinatra application on port 4567.
run! if app_file == $0