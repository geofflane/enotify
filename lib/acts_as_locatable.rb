module Enotify
  module Acts
    module Locatable
      def self.included(base)
        base.extend(ClassMethods)  
      end

      module ClassMethods
        def acts_as_locatable()
          extend Enotify::Acts::Locatable::SingletonMethods
        end
      end
      
      module SingletonMethods
        def find_by_zip(zip)
          find(:all, :joins => [:address], :conditions => ["addresses.zip=?", zip])
        end
        
        def find_by_address(street, zip)
          find(:all, :joins => [:address], :conditions => ["addresses.street=? AND addresses.zip=?", street, zip])
        end
        
        def find_by_address(start_number, end_number, street, zip)
          find(:all, :joins => [:address], :conditions => ["addresses.street_number between ? and ? AND addresses.street_name=? AND addresses.zip=?", start_number, end_number, street, zip])
        end
        
      end
    end
  end
end