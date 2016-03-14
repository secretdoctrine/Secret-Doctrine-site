module Refinery
  module NewsItems
    module Admin
      class NewsItemsController < ::Refinery::AdminController

        crudify :'refinery/news_items/news_item',
                :title_attribute => 'title'

        def create

          if (@news_item = NewsItem.create(news_item_params)).valid?
            flash.notice = t(
                'refinery.crudify.created',
                :what => @news_item.title
            )
            Refinery::NewsItems::NewsRecipient.not_opted_out.each do |recipient|
              begin
                DoctrineMailer.new_news_item(recipient.email, @news_item).deliver_later
              rescue Exception => e

                #print e

              end
            end
            create_or_update_successful
          else
            create_or_update_unsuccessful 'new'
          end

        end

        private

        # Only allow a trusted parameter "white list" through.
        def news_item_params
          params.require(:news_item).permit(:body, :library_news, :site_news, :news_datetime, :title)
        end
      end
    end
  end
end
