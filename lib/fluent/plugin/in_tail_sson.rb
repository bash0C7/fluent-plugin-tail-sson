require_relative '../text_parser/sson_parser.rb'

module Fluent
  class TailSSONInput < TailInput
    Plugin.register_input('tail_sson', self)

    TextParser.register_template('sson', Proc.new{TextParser::SSONParser.new})
  end
end
