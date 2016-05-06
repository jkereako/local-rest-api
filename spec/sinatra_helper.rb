ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require 'spec_helper'
require File.expand_path('../../app', __FILE__)
