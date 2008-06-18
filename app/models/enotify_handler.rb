require 'net/imap'

class EnotifyHandler < ActionMailer::Base
  
  @@router = EnotifyRouter.new('Milwaukee', 'WI')
  
  def receive(email)
    enotify_mail = @@router.create_from_mail(email)
    if enotify_mail
      if ! enotify_mail.save()
        Rails.logger.error("Failed to save item")
          if (enotify_mail.errors)
          enotify_mail.errors.each do |e|
            Rails.logger.error(e)
          end
        end
      end
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
