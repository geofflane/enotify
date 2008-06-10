class EnotifyHandler < ActionMailer::Base

  @@router = EnotifyRouter.new('Milwaukee', 'WI')
  
  def receive(email)
    enotify_mail = @@router.create_from_mail(email)
    enotify_mail.save()
  end
end
