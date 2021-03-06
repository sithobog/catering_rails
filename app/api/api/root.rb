require 'utils/logger'
require 'utils/failure_app'
require 'v1/root'

module API

  class UnauthorizedError < StandardError; end

  class Root < Grape::API

    #before do
    #  error!("401 Unauthorized", 401) unless authenticated
    #end

    rescue_from Grape::Exceptions::Validation do |e|
      Rack::Response.new({'errors' => e.message, 'param' => e.params}.to_json, 422, {"Content-Type" => "application/json"})
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      Rack::Response.new({'errors' => e.message}.to_json, 422, {"Content-Type" => "application/json"})
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      Rack::Response.new({'errors' => e.message, 'message' => "RecordNotFound"}.to_json, 404, {"Content-Type" => "application/json"})
    end

    rescue_from UnauthorizedError do |e|
      Rack::Response.new({'errors' => "Invalid API public token", 'message' => "Unauthorized"}.to_json, 401, {"Content-Type" => "application/json"})
    end

    use API::Logger

    mount API::V1::Root
    #mount API::V2::Root

  end
end
