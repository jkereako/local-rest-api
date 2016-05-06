require 'sinatra'
require 'uri'

# auth_url = "#{url}/authorize?client_id=#{Authorization::CLIENT_ID}&response_type=code"

helpers do
  def root_url(url)
    uri = URI.parse url
    "#{uri.scheme}://#{uri.host}:#{uri.port}"
  end

  def authorize_url(root_url)
    "#{root_url}/authorize?client_id=#{Authorization::CLIENT_ID}&response_type=code"
  end
end
