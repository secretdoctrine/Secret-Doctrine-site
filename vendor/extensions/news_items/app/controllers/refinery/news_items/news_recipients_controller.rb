module Refinery
  module NewsItems
    class NewsRecipientsController < ::ApplicationController

      def create

        if (@recipient = NewsRecipient.create(news_recipient_params)).valid?
          flash.notice = t('news_recipients.subscription_successful')
        else
          flash.alert = @recipient.errors.messages
        end

        redirect_to refinery.news_items_news_items_path

      end

      private

      # Only allow a trusted parameter "white list" through.
      def news_recipient_params
        params.require(:news_recipient).permit(:email, :name, :city)
      end

    end
  end
end
