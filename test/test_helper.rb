require 'test/unit'
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sql_parser'

Ast = SqlParser::Ast
def enable_debug
  indent = 0
  method_names = SqlParser::Oracle::OracleParser.instance_methods.grep(/_nt_.*/)
  method_names.each do |name|
    SqlParser::Oracle::OracleParser.send(:define_method, "#{name}_new") do
      indent = indent + 1
      if index != 0
        parsing_text = "#{input[0..index-1]}*#{input[index..-1]}"
      else
        parsing_text = "*#{input}"
      end
      puts(" " * indent + name.to_s + ":#{index}" + ": \t\t#{parsing_text}")
      result = send("#{name}_old")
      indent = indent - 1
      result
    end
    SqlParser::Oracle::OracleParser.class_eval do
      alias_method "#{name}_old", "#{name}"
      alias_method "#{name}", "#{name}_new"
    end
  end
end

def need_equal(expect, actual)
  difference = []
  unless expect == actual
    Ast::Base.find_different_value(expect, actual) do |left, right|
      difference << {:expect => left, :actual => right}
    end

    raise "found difference in ast\n"+difference.join("\n")+"\n\n" +
          "expect:#{expect.inspect}\n" +
          "actual:#{actual.inspect}\n"
  end
end

def generate_ast(query)
  parser = SqlParser::Oracle::OracleParser.new
  result = parser.parse query
  if result.nil?
    message = "\n#{query}\n" + " " * (parser.failure_column.to_i-1) + "*\n"
    raise parser.failure_reason + message
  end
  result.ast
end
