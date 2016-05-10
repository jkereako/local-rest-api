require 'sinatra_helper'

RSpec.describe 'API', type: 'routing' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'unauthenticated request for' do
    context '"/root"' do
      subject { get '/' }

      specify do
        expect(subject.status).to eq 200
        expect(subject.header['Content-Type']).to include 'text/html'
      end
    end

    context '"/authorize"' do
      subject { get '/authorize' }

      specify do
        expect(subject.status).to eq 400
        expect(subject.header['Content-Type']).to include 'text/html'
      end
    end

    context '"/authorize_submit"' do
      subject { get '/authorize_submit' }

      specify do
        expect(subject.status).to eq 404
        expect(subject.header['Content-Type']).to include 'text/html'
      end
    end

    context '"/zen"' do
      subject { get '/zen' }

      specify do
        expect(subject.status).to eq 401
        expect(subject.header['Content-Type']).to include 'application/json'
      end
    end
  end

  describe 'authenticated request for' do
    before :all do
      header 'Authorization', "Bearer #{Authorization::ACCESS_TOKEN}"
    end

    context '"/zen"' do
      subject { get '/zen' }

      specify do
        expect(subject.status).to eq 200
        expect(subject.header['Content-Type']).to include 'application/json'
      end
    end
  end
end
