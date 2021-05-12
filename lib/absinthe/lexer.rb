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
          MATCHERS.each do |matcher, id|
            matched = scanner.scan(matcher)
            next unless matched

            tokens << case matcher
                      when Regexp
                        [id, [line, pos], matched]
                      else
                        [id, [line, pos]]
                      end

            pos += matched.length
            break
          end

          if spacing = scanner.scan(/\s*/)
            pos += spacing.length
          end
        end

        tokens
      end
    end

    MATCHERS = {
      '{' => :left,
      '}' => :right,
      /(\w+)/ => :name
    }.freeze
  end
end
