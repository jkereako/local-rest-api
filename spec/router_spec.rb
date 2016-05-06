require 'sinatra_helper'

RSpec.describe 'API', type: 'routing' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'unauthenticated request for' do
    context '"/root"' do
      subject { get '/' }
      it { is_expected.to be_ok }
    end

    context '"/authorize"' do
      subject { get '/authorize' }
      it { is_expected.to_not be_ok }
    end

    context '"/authorize_submit"' do
      subject { get '/authorize_submit' }
      it { is_expected.to_not be_ok }
    end

    context '"/zen"' do
      subject { get '/zen' }
      it { is_expected.to_not be_ok }
    end
  end

  describe 'authenticated request for' do
    before :all do
      header 'Authorization', "Bearer #{Authorization::ACCESS_TOKEN}"
    end

    context '"/zen"' do
      subject { get '/zen' }
      it { is_expected.to be_ok }
    end
  end
end
