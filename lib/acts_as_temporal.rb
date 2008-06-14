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
          start = Date.parse("#{month}/1/#{year}").beginning_of_month
          find(:all, :conditions => ["incident_time between ? and ?", start.yesterday.end_of_day, start.end_of_month.end_of_day])
        end
      end
    end
  end
end