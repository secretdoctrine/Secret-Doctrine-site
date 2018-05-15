module Refinery
  module News
    module Admin
      class NewsItemsController < ::Refinery::AdminController

        crudify :'refinery/news/news_item',
                :title_attribute => 'title',
                :order => 'news_datetime DESC'

        #def index
        #  @setting = Setting.first
        #  @news_items = NewsItem.order('news_datetime DESC')
        #end

        before_action :find_setting, :only => :index

        def create

          if (@news_item = NewsItem.create(news_item_params)).valid?
            flash.notice = t(
                'refinery.crudify.created',
                :what => @news_item.title
            )
            Refinery::News::NewsRecipient.not_opted_out.each do |recipient|
              begin
                DoctrineMailer.new_news_item(recipient, @news_item).deliver_later
              rescue Exception => e

                #print e

              end
            end
            create_or_update_successful
          else
            create_or_update_unsuccessful 'new'
          end

        end

        def update

          category_ids = params[:news_item][:news_category_ids]
          @news_item.update_category_ids(category_ids)

          if @news_item.update_attributes(news_item_params)
            flash.notice = t(
                'refinery.crudify.updated',
                :what => "'#{@news_item.title}'"
            )
            create_or_update_successful
          else
            create_or_update_unsuccessful 'edit'
          end

        end

        private

        def find_setting
          @setting = Setting.first
        end

        def create_or_update_unsuccessful(action)

          redirect_to :back

        end

        # Only allow a trusted parameter "white list" through.
        def news_item_params
          params.require(:news_item).permit(:body, :library_news, :site_news, :news_datetime, :title, :category_ids, :is_pinned)
        end
      end
    end
  end
end
