require 'sinatra_helper'
require File.expand_path('../../lib/authorization', __FILE__)

RSpec.describe 'Authorization', type: 'routing' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'request' do
    before :all do
      @url = '/authorize'
    end

    # http://localhost:4567/authorize
    context 'without "client_id"' do
      subject { get @url }
      it { is_expected.to_not be_ok }
    end

    # http://localhost:4567/authorize?client_id=<bad_value>
    context 'with incorrect "client_id"' do
      subject { get @url, client_id: 'notreal' }
      it { is_expected.to_not be_ok }
    end

    context 'with "client_id" and' do
      # /authorize?client_id=<value>
      context 'without "response_type"' do
        subject { get @url, client_id: Authorization::CLIENT_ID }
        it { is_expected.to_not be_ok }
      end

      # /authorize?client_id=<value>&response_type=<bad_value>
      context 'with incorrect "response_type"' do
        subject do
          get @url, client_id: Authorization::CLIENT_ID,
                    response_type: 'notreal'
        end

        it { is_expected.to_not be_ok }
      end

      context 'with "response_type"' do
        # /authorize?client_id=<value>&response_type=code
        context '"code" and without "redirect_uri"' do
          subject do
            get @url, client_id: Authorization::CLIENT_ID, response_type: 'code'
          end

          it { is_expected.to be_ok }
        end

        context '"token"' do
          before :each do
            @response_type = 'token'
          end
          # /authorize?client_id=<value>&response_type=token
          context 'and without "redirect_uri"' do
            subject do
              get @url, client_id: Authorization::CLIENT_ID,
                        response_type: @response_type
            end

            it { is_expected.to_not be_ok }
          end

          # /authorize?client_id=<value>&response_type=token&redirect_uri=<bad_value>
          context 'with incorrect "redirect_uri"' do
            subject do
              get @url, client_id: Authorization::CLIENT_ID,
                        response_type: @response_type,
                        redirect_uri: 'notreal'
            end
            
            it { is_expected.to_not be_ok }
          end
        end
      end
    end
  end
end
