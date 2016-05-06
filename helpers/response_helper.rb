require 'sinatra'

#-- Response helpers
def bad_request(message)
  halt 400, erb(:error, locals: { message: message })
end

def unauthorized_request
  error = { success: false, message: 'Unauthorized access.' }
  halt 401, { 'Content-Type' => 'application/json' }, error.to_json
end
