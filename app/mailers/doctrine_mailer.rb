class DoctrineMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.doctrine_mailer.new_feedback.subject
  #

  def create_delivery_options(yaml_object)

    options = {
        address:              yaml_object['address'],
        port:                 yaml_object['port'].to_i,
        domain:               yaml_object['domain'],
        user_name:            yaml_object['user_name'],
        password:             yaml_object['password'],
        authentication:       yaml_object['authentication'],
        enable_starttls_auto: (yaml_object.has_key? 'enable_starttls_auto' and yaml_object['enable_starttls_auto'] == 'true'),
        delivery_method:      yaml_object['delivery_method']
    }

    options


  end

  def new_feedback(email, feedback_entry)
    @feedback_entry = feedback_entry

    yaml_object = YAML.load(File.read(File.join(Rails.root, 'config', 'mail_settings.yml')))

    mail from: yaml_object['from'],
         to: email,
         subject: 'Пользователь оставил новое сообщение',
         delivery_method_options: create_delivery_options(yaml_object)
  end

  def new_news_item(news_recipient, news_item)

    @news_recipient = news_recipient
    @news_item = news_item

    yaml_object = YAML.load(File.read(File.join(Rails.root, 'config', 'mail_settings.yml')))

    mail from: yaml_object['from'],
         to: news_recipient.email,
         subject: 'Добавлена новость',
         delivery_method_options: create_delivery_options(yaml_object)

  end

  def new_news_subscription(news_recipient)

    @news_recipient = news_recipient

    yaml_object = YAML.load(File.read(File.join(Rails.root, 'config', 'mail_settings.yml')))

    mail from: yaml_object['from'],
         to: news_recipient.email,
         subject: 'Активирована подписка на новости',
         delivery_method_options: create_delivery_options(yaml_object)

  end

end
