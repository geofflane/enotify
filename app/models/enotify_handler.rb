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

require 'net/imap'

class EnotifyHandler < ActionMailer::Base
  
  @@router = EnotifyRouter.new('Milwaukee', 'WI')
  
  def receive(email)
    enotify_mail = @@router.create_from_mail(email)
    if enotify_mail
      enotify_mail.save()
    end
  end
  
  def self.check_mail
    imap = Net::IMAP.new(IMAP_SERVER[:host], IMAP_SERVER[:port], IMAP_SERVER[:use_ssl], nil, false)
    imap.authenticate('LOGIN', IMAP_SERVER[:username], IMAP_SERVER[:password])
    imap.select('INBOX')
    imap.search(['ALL']).each do |message_id|
      
      begin
        msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']
              
        EnotifyHandler.receive(msg)
        
        # Mark message as deleted and it will be removed from storage when user session closd
        imap.copy(message_id, 'INBOX.Deleted Messages')
        imap.store(message_id, "+FLAGS", [:Deleted])
      rescue Exception => ex
        puts ex
      end
      
    end
    # tell server to permanently remove all messages flagged as :Deleted
    imap.expunge()
  end
end
