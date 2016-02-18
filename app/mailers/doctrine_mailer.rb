class DoctrineMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.doctrine_mailer.new_feedback.subject
  #

  def create_delivery_options

    options = {
        address:              'smtp.gmail.com',
        port:                 587,
        domain:               'gmail.com',
        user_name:            '__user__@gmail.com',
        password:             '__password__',
        authentication:       :login,
        enable_starttls_auto: true,
        delivery_method:      :smto
    }

    options


  end

  def new_feedback(feedback_entry)
    @feedback_entry = feedback_entry

    mail from: '__user__@gmail.com',
         to: "__target_user__@gmail.com",
         subject: 'new feedback',
         delivery_method_options: create_delivery_options
  end
end
