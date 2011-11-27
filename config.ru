# This file goes in domain.com/config.ru
ENV['PATH'] = ENV['PATH'] + ':/usr/local/bin'
require 'rubygems'
require 'sinatra'
 
set :env,  :production
set :env, (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :production)

disable :run

require 'booker.rb'

run Sinatra::Application
