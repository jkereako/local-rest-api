require 'sinatra'
require 'json'

#-- Response helpers
def normal_response(message)
  response = { success: true, message: message }
  halt 200, { 'Content-Type' => 'application/json' }, response.to_json
end

def bad_request(message)
  halt 400, erb(:error, locals: { title: 'Bad request (400)', message: message })
end

def unauthorized_request
  response = { success: false, message: 'Unauthorized access.' }
  halt 401, { 'Content-Type' => 'application/json' }, response.to_json
end
