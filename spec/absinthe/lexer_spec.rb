# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Absinthe::Lexer do
  it 'parses a basic document' do
    tokens = Absinthe::Lexer.new('{ foo }').tokens
    expect(tokens).to eq([
                           [:left, [1, 1]],
                           [:name, [1, 3], 'foo'],
                           [:right, [1, 7]]
                         ])
  end
end
