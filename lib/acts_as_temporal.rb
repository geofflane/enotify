module Enotify
  module Acts
    module Temporal
      def self.included(base)
        base.extend(ClassMethods)  
      end

      module ClassMethods
        def acts_as_temporal()
          extend Enotify::Acts::Temporal::SingletonMethods
        end
      end
      
      module SingletonMethods
        def find_by_month_and_year(month, year)
          start = Date.parse("#{month}/1/#{year}")
          find(:all, :conditions => ["time between ? and ?", start, start.end_of_month])
        end
      end
    end
  end
end