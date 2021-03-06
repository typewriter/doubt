#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/param'
require 'sinatra/reloader' if development?

require 'classifier-reborn'
require 'sanitize'

require 'faraday'

require './tokenizer.rb'

namespace '/doubt' do
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
    GC.start

    headers 'Access-Control-Allow-Origin' => '*'
    param :key, String, format: /^[a-zA-Z0-9\-]+$/, required: true
    param :data, String
    param :url, String

    html = if params[:data]
             params[:data]
           else
             html = Faraday.get(params[:url])&.body&.force_encoding('utf-8')
           end

    text = Sanitize.clean(html)
    text = text[0,16384] if text.size > 16384 # Avoid performance issue

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
    GC.start

    headers 'Access-Control-Allow-Origin' => '*'
    param :key, String, format: /^[a-zA-Z0-9\-]+$/, required: true
    param :data, String
    param :url, String
    param :class, String, format: /Like|Dislike/, required: true

    html = if params[:data]
             params[:data]
           else
             html = Faraday.get(params[:url])&.body&.force_encoding('utf-8')
           end

    text = Sanitize.clean(html)
    text = text[0,16384] if text.size > 16384 # Avoid performance issue

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
end
