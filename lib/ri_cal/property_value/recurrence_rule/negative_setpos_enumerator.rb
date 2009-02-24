module RiCal
  class PropertyValue
    class RecurrenceRule < PropertyValue

      class NegativeSetposEnumerator < Enumerator

        def initialize(recurrence_rule, component, setpos_list)
          super
          @current_set = []
          @valids = []
        end

        def next_occurrence
          while true
            result = advance
            if result >= start_time
              @count += 1
              return recurrence_rule.exhausted?(@count, result) ? nil : result_hash(result)
            end
          end
        end

        def advance
          if @valids.empty?
            fill_set
            @valids = @setpos_list.map {|sp| sp < 0 ? @current_set.length + sp : sp - 1}
            current_time_index = @current_set.index(@start_time)
            if current_time_index
              @valids << current_time_index
            end
            @valids = @valids.uniq.sort
          end
          @current_set[@valids.shift]
        end


        def fill_set
          @current_set = [next_time]
          while true
            self.next_time = recurrence_rule.advance(next_time, self)
            if recurrence_rule.in_same_set?(@current_set.last, next_time)
              @current_set << next_time
            else
              return
            end
          end
        end
      end
    end
  end
end
