require_relative '../config/environment'

# Vercel serverless handler
module Vercel
  class Rack
    def self.handler(req, res)
      # Convert Vercel request to Rack environment
      env = {
        'REQUEST_METHOD' => req['httpMethod'] || 'GET',
        'SCRIPT_NAME' => '',
        'PATH_INFO' => req['path'] || '/',
        'QUERY_STRING' => req['queryStringParameters'] ? 
          req['queryStringParameters'].map { |k, v| "#{k}=#{v}" }.join('&') : '',
        'SERVER_NAME' => req['headers']['host'] || 'localhost',
        'SERVER_PORT' => req['headers']['x-forwarded-port'] || '443',
        'SERVER_PROTOCOL' => 'HTTP/1.1',
        'rack.url_scheme' => req['headers']['x-forwarded-proto'] || 'https',
        'rack.input' => StringIO.new(req['body'] || ''),
        'rack.errors' => $stderr,
        'rack.multithread' => true,
        'rack.multiprocess' => false,
        'rack.run_once' => false,
      }

      # Add headers
      (req['headers'] || {}).each do |key, value|
        key = key.upcase.gsub('-', '_')
        key = "HTTP_#{key}" unless %w[CONTENT_TYPE CONTENT_LENGTH].include?(key)
        env[key] = value
      end

      # Call Rails application
      status, headers, body = ::Rails.application.call(env)

      # Format response for Vercel
      body_str = body.respond_to?(:read) ? body.read : body.join
      
      {
        'statusCode' => status,
        'headers' => headers,
        'body' => body_str,
        'isBase64Encoded' => false
      }
    end
  end
end

handler = lambda { |req, res| Vercel::Rack.handler(req, res) }
