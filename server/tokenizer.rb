require 'natto'
require 'classifier-reborn'

module JapaneseTokenizer
  module_function
  def call(text)
    nm = Natto::MeCab.new
    nm.enum_parse(text).map { |n| ClassifierReborn::Tokenizer::Token.new(n.surface) }
  end
end
