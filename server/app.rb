#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/param'
require 'sinatra/reloader' if development?

require 'classifier-reborn'
require 'sanitize'

require 'faraday'

require './tokenizer.rb'

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
  JapaneseTokenizer.call(text).join(',')
end

post '/classify' do
  headers 'Access-Control-Allow-Origin' => '*'
  param :key, String, format: /^[A-Z0-9]+$/, required: true
  param :data, String
  param :url, String

  html = if params[:data]
           params[:data]
         else
           html = Faraday.get(params[:url])&.body&.force_encoding('utf-8')
         end

  text = Sanitize.clean(html)

  filename = "./#{params[:key]}.dat"
  classifier = if File.exist?(filename)
                 Marshal.load(File.read(filename))
               else
                 halt 400, 'key not found'
               end

  content_type :json
  (classifier.classifications text).to_json
end

post '/learn' do
  headers 'Access-Control-Allow-Origin' => '*'
  param :key, String, format: /^[A-Z0-9]+$/, required: true
  param :data, String
  param :url, String
  param :class, String, format: /Like|Dislike/, required: true

  html = if params[:data]
           params[:data]
         else
           html = Faraday.get(params[:url])&.body&.force_encoding('utf-8')
         end

  text = Sanitize.clean(html)

  filename = "./#{params[:key]}.dat"
  classifier = if File.exist?(filename)
                 Marshal.load(File.read(filename))
               else
                 ClassifierReborn::Bayes.new tokenizer: JapaneseTokenizer
               end

  classifier.train params[:class], text

  File.open(filename, "w") { |f| f.write Marshal.dump(classifier) }

  "Learned #{params[:class]}"
end

