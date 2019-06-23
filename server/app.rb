#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/param'
require 'sinatra/reloader' if development?

require 'natto'
require 'classifier-reborn'

require 'sanitize'

require 'faraday'

get '/' do
  'hello world!'
end

post '/tokenize' do
  headers 'Access-Control-Allow-Origin' => '*'
  param :key, String, required: true
  param :data, String
  param :url, String

  html = if params[:data]
           params[:data]
         else
           html = Faraday.get(params[:url])&.body&.force_encoding('utf-8')
         end

  text = Sanitize.clean(html)

  nm = Natto::MeCab.new
  nm.enum_parse(text).map { |n| n.surface }.join(',')
end

post '/classify' do
  headers 'Access-Control-Allow-Origin' => '*'
  param :key, String, required: true
  param :data, String
  param :url, String

  'Not implemented'
end

post '/learn' do
  headers 'Access-Control-Allow-Origin' => '*'
  param :key, String, required: true
  param :data, String
  param :url, String
  param :class, String, required: true

  'Not implemented'
end

