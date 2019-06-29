require 'natto'
require 'classifier-reborn'

module JapaneseTokenizer
  module_function
  def call(text)
    nm = Natto::MeCab.new
    nm.enum_parse(text).map { |n| n.surface }.take(4096).map { |n| ClassifierReborn::Tokenizer::Token.new(n) } # Avoid performance issue
  end
end
