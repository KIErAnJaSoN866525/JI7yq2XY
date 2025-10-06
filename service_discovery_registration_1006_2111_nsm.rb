# 代码生成时间: 2025-10-06 21:11:41
# Service Discovery and Registration using Ruby and Sinatra
#
# This application serves as a simple service discovery and registration system.
# It allows services to register themselves and clients to discover available services.

require 'sinatra'
require 'json'
require 'redis'

# Configure Redis
redis = Redis.new

# Endpoint to register a service
get '/register' do
  content_type :json
  # Extract the service details from the request parameters
  service_name = params['name']
  service_url = params['url']
  service_description = params['description']

  # Validate the input parameters
  unless service_name && service_url
    status 400
    { error: 'Missing service name or URL' }.to_json
    return
  end

  # Register the service in Redis
  redis.setex(service_name, 3600, service_url) # TTL of 1 hour
  redis.hset('service:info', service_name, service_description)

  { message: 'Service registered successfully' }.to_json
end

# Endpoint to discover services
get '/discover/:name' do
  content_type :json
  service_name = params['name']

  # Check if the service is registered
  service_url = redis.get(service_name)
  if service_url
    service_description = redis.hget('service:info', service_name)
    {
      service_name: service_name,
      service_url: service_url,
      service_description: service_description
    }.to_json
  else
    status 404
    { error: 'Service not found' }.to_json
  end
end
