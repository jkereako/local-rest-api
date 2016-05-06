require 'sinatra'
require 'json'
require 'tilt/erb'
require File.expand_path('../lib/authorization', __FILE__)

#-- Filters
before '/*/?' do
  # Skip these paths
  pass if request.path_info == '/'
  pass if %w( authorize authorize_submit).include? request.path_info.split('/')[1]

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

  if params['response_type'] != 'code' && params['response_type'] != 'token'
    bad_request "Invalid response_type '#{params['response_type']}'"
  end

  # Check `redirect_uri`
  if params['response_type'] == 'token' && !params['redirect_uri']
    bad_request 'Missing redirect_uri (required when "response_type" is "token")'

  elsif params['response_type'] == 'token' && params['redirect_uri']
    if params['redirect_uri'] != Authorization::REDIRECT_URI
      bad_request "Invalid redirect_uri '#{params['redirect_uri']}'"
    end
  end
end

get '/' do
  erb :index, locals: { url: request.url, access_token: Authorization::ACCESS_TOKEN }
end

#-- Authorization endpoints
get '/authorize/?' do
  erb :authorize, locals: { response_type: params['response_type'] }
end

post '/authorize_submit/?' do
  # Redirect the user to root if he or she denied access
  redirect to '/' if params['deny']

  # Display the access token if the asked for a code
  if params['response_type'] == 'code'
    erb :authorize_submit, locals: { access_token: Authorization::ACCESS_TOKEN }
  # Else, rediect the user to the `redirect_uri`
  else
    redirect params['redirect_uri']
  end
end

#-- Endpoints
# https://api.github.com/zen
get '/zen/?' do
  quotes = ['Practicality beats purity.', 'Favor focus over features.',
            'It\'s not fully shipped until it\'s fast.',
            'Keep it logically awesome.', 'Responsive is better than fast.',
            'Half measures are as bad as nothing at all.']

  halt 200, { 'Content-Type' => 'text/plain' }, quotes.sample
end

#-- Response helpers
private def bad_request(message)
  halt 400, erb(:error, locals: { message: message })
end

private def unauthorized_request
  error = { success: false, message: 'Unauthorized access.' }
  halt 401, { 'Content-Type' => 'application/json' }, error.to_json
end
