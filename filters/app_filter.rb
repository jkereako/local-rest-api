require 'uri'
require 'sinatra'
require File.expand_path('../../helpers/response_helper', __FILE__)
require File.expand_path('../../lib/authorization', __FILE__)

#-- Filters
before '/*/?' do
  # Skip these paths
  pass if request.path_info == '/'
  pass if %w(authorize authorize_submit).include? request.path_info.split('/')[-1]

  # Check the access token
  unless "Bearer #{Authorization::ACCESS_TOKEN}" == request.env['HTTP_AUTHORIZATION']
    unauthorized_request
  end
end

before '/authorize/?' do
  # Check `client_id`
  bad_request 'Missing parameter client_id' unless params['client_id']

  unless params['client_id'] == Authorization::CLIENT_ID
    bad_request "Invalid client_id '#{params['client_id']}'"
  end

  # Check `response_type`
  bad_request 'Missing response_type' unless params['response_type']

  unless Authorization::RESPONSE_TYPES.include? params['response_type']
    bad_request "Invalid response_type '#{params['response_type']}'"
  end

  # Check `redirect_uri`
  if params['response_type'] == 'token' && !params['redirect_uri']
    bad_request 'Missing redirect_uri (required when "response_type" is "token")'

  elsif params['response_type'] == 'token' && params['redirect_uri']
    redirect_uri = URI(params['redirect_uri'])

    if redirect_uri != Authorization::REDIRECT_URI
      bad_request "Invalid redirect_uri '#{redirect_uri}'"
    end
  end
end
