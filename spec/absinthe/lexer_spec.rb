# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Absinthe::Lexer do
  it 'parses a basic document' do
    tokens = Absinthe::Lexer.new('{ foo }').tokens
    expect(tokens).to eq([
                           [:bracket_left, [1, 1]],
                           [:name, [1, 3], 'foo'],
                           [:bracket_right, [1, 7]]
                         ])
  end

  it 'parses a document with a name that starts with a keyword' do
    tokens = Absinthe::Lexer.new('{ nullName }').tokens
    expect(tokens).to eq([
                           [:bracket_left, [1, 1]],
                           [:name, [1, 3], 'nullName'],
                           [:bracket_right, [1, 12]]
                         ])
  end

  it 'parses a document with multiple lines' do
    tokens = Absinthe::Lexer.new(<<~GQL).tokens
      {
        foo
      }
    GQL
    expect(tokens).to eq([
                           [:bracket_left, [1, 1]],
                           [:name, [2, 3], 'foo'],
                           [:bracket_right, [3, 1]]
                         ])
  end

  it 'allows multiple escaped slashes' do
    tokens = Absinthe::Lexer.new(<<~GQL).tokens
      {
        { foo(bar: "\\\\FOO") }
      }
    GQL
    expect(tokens).to eq([
                           [:bracket_left, [1, 1]],
                           [:bracket_left, [2, 3]],
                           [:name, [2, 5], 'foo'],
                           [:paren_left, [2, 8]],
                           [:name, [2, 9], 'bar'],
                           [:colon, [2, 12]],
                           [:string, [2, 14], '"\\FOO"'],
                           [:paren_right, [2, 23]],
                           [:bracket_right, [2, 25]],
                           [:bracket_right, [3, 1]]
                         ])
  end
end
