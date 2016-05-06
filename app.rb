require 'sinatra'
require 'json'

class OAuth2
  CLIENT_ID = 'zm2adpwtdxiph3m'.freeze
  ACCESS_TOKEN = 'HRD2VjScOqAAAAmwZ-DSI_SL1EVO-AQSYhQDXUWsQ9G2Bp_d3LGhj3'.freeze
  REDIRECT_URI = 'myapp://com.myapp.project'.freeze
end

get '/' do
  erb :index
end

before '/authorize' do
  # Check `client_id`
  bad_request 'Missing parameter client_id' unless params['client_id']

  unless params['client_id'] == OAuth2::CLIENT_ID
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
    if params['redirect_uri'] != OAuth2::REDIRECT_URI
      bad_request "Invalid redirect_uri '#{params['redirect_uri']}'"
    end
  end
end

get '/authorize' do
  erb :authorize
end

post '/authorize_submit' do
  # Redirect the user to root if he or she denied access
  redirect to '/' if params['deny']

  # Display the access token if the asked for a code
  if params['response_type'] != 'code'
    erb :authorize_submit, locals: { access_token: OAuth2::ACCESS_TOKEN }
  end

  # Else, rediect the user to the `redirect_uri`
  redirect params['redirect_uri']
end

private def bad_request(message)
  halt 400, erb(:error, locals: { message: message })
end
