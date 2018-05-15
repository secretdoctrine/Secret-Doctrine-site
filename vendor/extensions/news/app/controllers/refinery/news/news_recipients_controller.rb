module Refinery
  module News
    class NewsRecipientsController < ::ApplicationController

      def create

        @recipient = NewsRecipient.find_by_email(news_recipient_params[:email])
        if @recipient
          @recipient.update(news_recipient_params)
          @recipient.opt_in
        else
          @recipient = NewsRecipient.create(news_recipient_params)
        end

        if @recipient.valid?
          flash.notice = t('news_recipients.subscription_successful')

          begin
            DoctrineMailer.new_news_subscription(@recipient).deliver_later
          rescue Exception => e
            #print e
          end

        else
          flash.alert = @recipient.errors.messages
        end

        redirect_to refinery.news_news_items_path

      end

      private

      # Only allow a trusted parameter "white list" through.
      def news_recipient_params
        params.require(:news_recipient).permit(:email, :name, :city)
      end

    end
  end
end
