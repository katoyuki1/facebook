class NoticeMailer < ApplicationMailer
  def sendmail_topic(topic)
    @topic = topic

    mail(
      to:      "0me3210g039530z@gmail.com",
      subject: '【Facebook】投稿されました',
    ) do |format|
      format.html
    end
  end
end
