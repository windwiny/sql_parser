require 'test/unit'
require 'test/unit/assertions'
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sql_parser'

module Test::Unit::Assertions
  def assert_ast_equal(expect, actual)
    difference = []
    SqlParser::Ast::Base.find_different_value(expect, actual) do |left, right|
      difference << {:expect => left, :actual => right}
    end
    full_message = build_message(<<EOS)
found difference in ast
#{difference.join("\n")}


expect:#{expect.inspect}
actual:#{actual.inspect}
EOS

    assert_block(full_message) do
      expect == actual
    end
  end
end

