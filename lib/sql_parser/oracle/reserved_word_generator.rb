module SqlParser
  module Oracle
    class ReservedWordGenerator
      def self.generate_grammer
        filename = ARGV[1] || File.expand_path("./reserved_word.treetop", File.dirname(__FILE__))
        File.open(filename, 'w') do |f|
          f.write self.generate_grammer_string(filename)
        end
      end
  
      class KeywordRule
        attr_reader :keyword
        def initialize(keyword)
          @keyword = keyword
        end
  
        def to_s
          content = []
          content << "    rule #{rule_name}"
          content << "      #{matcher} <SqlParser::Keyword>"
          content << "    end"
          content.join("\n")
        end
  
        def rule_name
          "#{@keyword.downcase}_keyword"
        end
  
        def matcher
          matcher = []
          keyword.each_char do |ch|
            if ch.match(/[A-Z]/)
              matcher << "[#{ch.downcase}#{ch.upcase}]"
            else
              matcher << "'#{ch}'"
            end
          end
          matcher << '( ![A-Za-z0-9] )'
          matcher.join(' ')
        end
      end
  
      class MatchKeyword < Array
        attr_reader :rule_name
        def initialize(rule_name)
          @rule_name = rule_name
        end
  
        def to_s
          content = []
          content << "    rule #{rule_name}"
          content << "      [a-zA-Z0-9_]+ ![a-zA-Z0-9] &{|w| #{self.to_a.to_s}.include? w.first.text_value.upcase}"
          content << "    end"
          content.join("\n")
        end
      end
  
      def self.generate_grammer_string(filename)
        header = <<EOS
#
# #{File.basename(filename)} generated by #{__FILE__} at #{Time.now}
#
module SqlParser::Oracle
  grammar ReservedWord
EOS
        content = []
  
        footer = <<EOS
  end
end
EOS
        not_match_keyword = MatchKeyword.new 'keyword'
        self.keywords.each do |keyword|
          rule = KeywordRule.new(keyword)
          content << rule.to_s
          not_match_keyword << keyword
        end
  
        content.unshift not_match_keyword.to_s
        header + content.join("\n") + footer
      end
  
      def self.keywords
        [
          'ACCESS',
          'ADD',
          'ALL',
          'ALTER',
          'AND',
          'ANY',
          'AS',
          'ASC',
          'AUDIT',
          'BETWEEN',
          'BY',
          'CASE',
          'CHAR',
          'CHECK',
          'CLUSTER',
          'CURRENT_OF',
          'COLUMN',
          'COLUMN_VALUE',
          'COMMENT',
          'COMPRESS',
          'CONNECT',
          'CREATE',
          'CROSS',
          'CUBE',
          'CURRENT',
          'CURRVAL',
          'DATE',
          'DECIMAL',
          'DEFAULT',
          'DELETE',
          'DESC',
          'DISTINCT',
          'DROP',
          'ELSE',
          'END',
          'ESCAPE',
          'EXCLUSIVE',
          'EXISTS',
          'FILE',
          'FIRST',
          'FLOAT',
          'FOR',
          'FROM',
          'FULL',
          'GRANT',
          'GROUP',
          'HAVING',
          'IDENTIFIED',
          'IMMEDIATE',
          'IN',
          'INCREMENT',
          'INDEX',
          'INITIAL',
          'INNER',
          'INSERT',
          'INTEGER',
          'INTERSECT',
          'INTO',
          'IS',
          'JOIN',
          'LAST',
          'LEFT',
          'LEVEL',
          'LIKE',
          'LIKE2',
          'LIKE4',
          'LIKEC',
          'LOCK',
          'LONG',
          'MAXEXTENTS',
          'MINUS',
          'MLSLABEL',
          'MODE',
          'MODIFY',
          'NATURAL',
          'NESTED_TABLE_ID',
          'NEXTVAL',
          'NOAUDIT',
          'NOCOMPRESS',
          'NOT',
          'NOWAIT',
          'NULL',
          'NULLS',
          'NUMBER',
          'OF',
          'OFFLINE',
          'ON',
          'ONLINE',
          'OPTION',
          'OR',
          'ORDER',
          'OUTER',
          'PCTFREE',
          'PRIOR',
          'PRIVILEGES',
          'PUBLIC',
          'RAW',
          'REGEXP_LIKE',
          'RENAME',
          'RESOURCE',
          'REVOKE',
          'RIGHT',
          'ROLLUP',
          'ROW',
          'ROWID',
          'ROWNUM',
          'ROWS',
          'SELECT',
          'SESSION',
          'SET',
          'SHARE',
          'SIZE',
          'SIBLINGS',
          'SMALLINT',
          'START',
          'SUCCESSFUL',
          'SYNONYM',
          'SYSDATE',
          'TABLE',
          'THEN',
          'TO',
          'TRIGGER',
          'UID',
          'UNION',
          'UNIQUE',
          'UPDATE',
          'USER',
          'USING',
          'VALIDATE',
          'VALUES',
          'VARCHAR',
          'VARCHAR2',
          'VIEW',
          'WAIT',
          'WHEN',
          'WHENEVER',
          'WHERE',
        ]
      end
    end
  end
end

SqlParser::Oracle::ReservedWordGenerator.generate_grammer
