require 'yaml'
require 'uri'
require 'sinatra'
require 'tilt/erb'
require File.expand_path('../lib/authorization', __FILE__)
require File.expand_path('../helpers/app_helper', __FILE__)
require File.expand_path('../filters/app_filter', __FILE__)

get '/' do
  url = root_url request.url
  auth_url = authorize_url url

  erb :index, locals: { auth_url: auth_url,
                        url: root_url(request.url),
                        access_token: Authorization::ACCESS_TOKEN }
end

#-- Authorization endpoints
get '/authorize/?' do
  erb :authorize, locals: {
    response_type: params['response_type'], state: params['state']
  }
end

post '/authorize_submit/?' do
  # Redirect the user to root if he or she denied access
  redirect to '/' if params['deny']

  # Display the access token if the asked for a code
  if params['response_type'] == 'code'
    erb :authorize_submit, locals: { access_token: Authorization::ACCESS_TOKEN }
  # Else, rediect the user to the `redirect_uri`
  else
    args = [
      ['access_token', Authorization::ACCESS_TOKEN], %w(token_type bearer)
    ]

    args.push ['state', params['state']] if params['state']
    # myapp://com.myapp.project/#access_token=HRD2VjS...&token_type=bearer&state=this+is+a+test
    redirect "#{Authorization::REDIRECT_URI}/##{URI.encode_www_form args}"
  end
end

#-- Endpoints
# https://api.github.com/zen
get '/zen/?' do
  quotes = YAML.load_file static_dir '/yaml/quotes.yml'

  normal_response quotes.sample
end
