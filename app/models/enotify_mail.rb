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

class EnotifyMail < ActiveRecord::Base
  has_one :incident
  
  def success
    read_attribute(:success) or true
  end
  
  def inner_html
    doc = Hpricot(original_text)
    body = doc.at('body')
    body = doc if ! body
    body.inner_html
  end
  
  def set_error(ex)
    success = false
    parse_error = ex
  end
end
