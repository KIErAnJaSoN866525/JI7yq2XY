# 代码生成时间: 2025-08-21 23:45:49
# HashCalculatorApp is a Sinatra application that provides a simple hash calculation tool.
class HashCalculatorApp < Sinatra::Base
  # Endpoint to calculate SHA256 hash for provided data.
  get '/hash/sha256' do
    # Retrieve the data from query parameter.
    data = params[:data]

    # Check if the data is provided and respond with an error if not.
    if data.nil? || data.empty?
      status 400
      "Error: No data provided."
    else
      # Calculate SHA256 hash using Digest module.
      hash = Digest::SHA256.hexdigest(data)
      # Return the calculated hash as a JSON response.
      content_type :json
      { hash: hash }.to_json
    end
  end
end

# Run the Sinatra application if this file is executed.
run! if __FILE__ == $0