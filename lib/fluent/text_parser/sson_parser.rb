require 'nendo'

module Fluent
  class TextParser
    class SSONParser
      include Configurable

      config_param :time_key, :string, :default => 'time'
      config_param :time_format, :string, :default => nil
      
      def call(text)
        nend_cell = nendo.readFromString(text)
        raise RuntimeError 'Invalid sson' unless nend_cell.respond_to? :car
        
        record = nend_cell.inject({}) do |hash, cell|
          key = cell.car.car.to_s
          value = cell.car.cdr.car
          
          hash[key] = value
          hash
        end

        if value = record.delete(@time_key)
          if @time_format
            time = Time.strptime(value, @time_format).to_i
          else
            time = value.to_i
          end
        else
          time = Engine.now
        end

        return time, record
        
      rescue RuntimeError
        $log.warn "pattern not match: #{text.inspect}: #{$!}"
        return nil, nil
      end

      private
      
      def nendo
        return @nendo_core if @nendo_core
        
        @nendo_core = Nendo::Core.new
        @nendo_core.loadInitFile
        @nendo_core.evalStr '(define (readFromString string) (read-from-string string))'
        @nendo_core.evalStr '(export-to-ruby readFromString)'
        @nendo_core
      end
    end
  end
end
