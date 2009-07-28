# Milwaukee Enotify Deconstructed
# Copyright (C) 2009 Geoff Lane <geoff@zorched.net>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


class FilterSweeper < ActionController::Caching::Sweeper
  observe Incident

  # If our sweeper detects that a Incident was created call this
  def after_create(incident)
    expire_cache_fragment(incident)
  end
  
  # If our sweeper detects that a Incident was deleted call this
  def after_destroy(incident)
    expire_cache_fragment(incident)
  end
          
  private
  def expire_cache_fragment(incident)
    cache_name = "#{incident.class.name}_filter"
    expire_fragment(cache_name)
  end
end