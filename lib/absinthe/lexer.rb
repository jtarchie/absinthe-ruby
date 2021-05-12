# frozen_string_literal: true

require 'strscan'

module Absinthe
  class Lexer
    def initialize(query)
      @query = query
    end

    def tokens
      @tokens ||= begin
        tokens = []
        line = 1
        pos = 1

        scanner = StringScanner.new(@query)
        until scanner.eos?
          performed = MATCHERS.any? do |matcher, id|
            if matched = scanner.scan(matcher)
              tokens << case matcher
                        when Regexp
                          [id, [line, pos], matched]
                        else
                          [id, [line, pos]]
                        end

              pos += matched.length
            end
          end

          if spacing = scanner.scan(/ +/)
            pos += spacing.length
            performed ||= true
          end
          
          if newlines = scanner.scan(/\n+/)
            pos = 1
            line += newlines.length
            performed ||= true
          end

          break unless performed
        end

        tokens
      end
    end

    MATCHERS = {
      '{' => :bracket_left,
      '}' => :bracket_right,
      '(' => :paren_left,
      ')' => :paren_right,
      ':' => :colon,
      /(\w+)/ => :name,
      /(".*?")/ => :string,
    }.freeze
  end
end
