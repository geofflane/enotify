require 'acts_as_temporal'
require 'acts_as_locatable'
ActiveRecord::Base.send(:include, Enotify::Acts::Temporal)
ActiveRecord::Base.send(:include, Enotify::Acts::Locatable)