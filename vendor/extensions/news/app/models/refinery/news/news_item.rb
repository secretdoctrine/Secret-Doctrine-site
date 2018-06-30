module Refinery
  module News
    class NewsItem < Refinery::Core::BaseModel
      #self.table_name = 'refinery_news_items'
      has_many :item_categories, :foreign_key => 'news_items_news_item_id'
      has_many :news_categories, :through => 'item_categories'
      self.table_name = 'refinery_books_news_items'

      after_commit :reindex

      RESULTS_ON_PAGE = 10
      MAX_SEARCH_RESULTS = 1000
      PAGE_NAME_EXPORT_LIMIT = 30
      BOOK_NAME_EXPORT_LIMIT = 30
      NAME_SEPARATOR = ' / '

      def reindex
        `indexer --config #{Rails.root}/config/production.sphinx.conf refinery_news_news_item_core --rotate &`
        `indexer --config #{Rails.root}/config/development.sphinx.conf refinery_news_news_item_core --rotate &`
      end

      def is_fresh?()

        (news_datetime >(DateTime.now - Setting.first.fresh_interval_in_months.month))

      end

      def self.default_time_in_months
        Setting.first.default_interval_in_months
      end

      def self.filter_by_params(collection, params)

        result = {}
        result[:unfiltered_news] = collection
        result[:filtered_news] = collection
        #result[:years] = collection.collect{|x| x.news_datetime.year}.uniq.sort.reverse
        result[:years] = {}
        collection.collect{|x| x.news_datetime.year}.uniq.sort.reverse.each do |year|
          result[:years][year] = collection.select{|x| x.news_datetime.year == year}.collect{|x| x.news_datetime.month}.uniq.sort.reverse
        end
        result[:selected_year] = nil
        result[:has_period_filter] = false
        result[:no_more_entries] = false
        #result[:pinned_news] = collection
        result[:pinned_news] = NewsItem.where(:is_pinned => true).order('news_datetime DESC')
        result[:not_pinned_news] = collection

        if collection.length == 0
          result[:no_more_entries] = true
          return result
        end

        db_first_entry_datetime = collection.order('news_datetime ASC').first.news_datetime
        first_entry_datetime = DateTime.new(
            db_first_entry_datetime.year,
            db_first_entry_datetime.month,
            db_first_entry_datetime.day,
            db_first_entry_datetime.hour,
            db_first_entry_datetime.min,
            db_first_entry_datetime.sec)


        if params.has_key? :fixed_year and not params.has_key? :prev_period_start
          result[:selected_year] = params[:fixed_year].to_i
          result[:selected_month] = nil
          period_start = DateTime.new(result[:selected_year], 1, 1)
          period_end = DateTime.new(result[:selected_year] + 1, 1, 1)
        elsif params.has_key? :fixed_month and params.has_key? :month_year and not params.has_key? :prev_period_start
          result[:selected_year] = params[:month_year].to_i
          result[:selected_month] = params[:fixed_month].to_i
          period_start = DateTime.new(result[:selected_year], result[:selected_month], 1)
          if result[:selected_month] == 12
            period_end = DateTime.new(result[:selected_year] + 1, 1, 1)
          else
            period_end = DateTime.new(result[:selected_year], result[:selected_month] + 1, 1)
          end
        else

          if params.has_key? :prev_period_start
            interval = 3.month
            period_end = params[:prev_period_start].to_datetime


          else
            period_end = DateTime.now

            if params.has_key? :period
              if params[:period] == 'last_3_months'
                interval = 3.month
              elsif params[:period] == 'last_year'
                interval = 1.year
              elsif params[:period] == 'default'
                interval = self.default_time_in_months.months
              elsif params[:period] == 'all'
                # +1 is just to be sure
                interval = ((period_end - first_entry_datetime).to_i + 1.day)*24
              else
                interval = self.default_time_in_months.months
              end
              result[:selected_period] = params[:period]
            else
              interval = self.default_time_in_months.months
              result[:selected_period] = 'default'
            end
          end

          period_start = period_end - interval
          while result[:filtered_news]
                    .where('news_datetime >= ?', period_start)
                    .where('news_datetime < ?', period_end)
                    .where(:is_pinned => false)
                    .length == 0
            period_start = period_start - 3.month
            break if period_start < first_entry_datetime
          end

          result[:no_more_entries] = true if period_start < first_entry_datetime

        end



        result[:filtered_news] = result[:filtered_news].where('news_datetime >= ?', period_start).where('news_datetime < ?', period_end)
        result[:period_start] = period_start



        result[:filtered_news] = result[:filtered_news].order('news_datetime DESC')
        #result[:pinned_news] = result[:unfiltered_news].where(:is_pinned => true).order('news_datetime DESC')
        result[:not_pinned_news] = result[:filtered_news].where(:is_pinned => false).order('news_datetime DESC')

        result

      end

      # this does not call save !!!!!!
      def update_category_ids(category_ids)

        return if category_ids.nil?

        categories_array = []

        category_ids.each do |category_id|
          category = NewsCategory.find(category_id)
          if category.nil?
            return false
          end
          categories_array.append(category)
        end

        self.item_categories.delete_all
        categories_array.each { |x|  self.news_categories << x }

      end

      validates :body, :presence => true

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

      def self.sphinx_search(params, results_per_page = nil)

        result = {}
        with_hash = {}
        search_text = (params[:search_text] or '')

        datetime_start = nil
        datetime_end = nil
        if params.has_key? :date_start and not params[:date_start].empty?
          datetime_start = Date.strptime(params[:date_start], "%d.%m.%Y")
        end

        if params.has_key? :date_end and not params[:date_end].empty?
          datetime_end = Date.strptime(params[:date_end], "%d.%m.%Y")
        end

        #show_extended_search = (params.has_key?('is_ext_search') and params['is_ext_search'] == 'true')
        per_page = RESULTS_ON_PAGE
        per_page = results_per_page unless results_per_page.nil?
        per_page = params['per_page'].to_i if params.has_key?('per_page')

        search_text_array = search_text.split(' ').collect{ |x| x.strip }.select{|x| not x.empty?}
        if params.has_key?('search_exact_words') and params['search_exact_words'] == 'true'
          search_text_array = search_text_array.collect{ |x| "=#{x}" }
        else
          search_text_array = search_text_array.collect{ |x| "#{x}" }
        end
        search_text = search_text_array.join(' & ')

        news_category_ids = []
        if params.has_key? :news_category_ids
          params[:news_category_ids].each do |id|
            news_category = NewsCategory.find_by_id(id.to_i)
            next if news_category.nil?
            news_category_ids.append(news_category.id)
          end

          unless news_category_ids.empty?
            with_hash[:news_items_news_category_id] = news_category_ids
          end

        end

        if not datetime_start.nil? and datetime_end.nil?
          with_hash[:news_datetime] = datetime_start..(DateTime.now.to_date + 1.day)
        elsif datetime_start.nil? and not datetime_end.nil?
          with_hash[:news_datetime] = Date.new(2000, 1, 1)..(datetime_end + 1.day)
        elsif not datetime_start.nil? and not datetime_end.nil?
          with_hash[:news_datetime] = datetime_start..(datetime_end + 1.day)
        end

        result[:date_start] = ''
        result[:date_start] = datetime_start.strftime("%d.%m.%Y") unless datetime_start.nil?

        result[:date_end] = ''
        result[:date_end] = datetime_end.strftime("%d.%m.%Y") unless datetime_end.nil?

        result[:per_page] = per_page

        #
        should_not_search = (search_text.empty? and news_category_ids.empty?)
        #should_not_search = false
        result[:should_not_search] = should_not_search

        if should_not_search
          result[:count] = 0
        else
          result[:count] = NewsItem.search_count(search_text, with: with_hash)
        end
        result[:too_many_results] = result[:count] >= MAX_SEARCH_RESULTS

=begin
        if should_not_search
          result[:book_category_ids] = []
        else
          result[:book_category_ids] = BookPage.search(
              search_text,
              per_page: MAX_SEARCH_RESULTS,
              group_by: 'book_category_id'
          ).collect{|x| x.book.book_category_id}
        end
=end

        page = 1
        page = params[:page].to_i if params.has_key? :page
        if page*per_page > result[:count]
          page = (result[:count].to_f / per_page).ceil
        end
        page = 1 if page <= 0

        order_string = ''
        if params.has_key?('use_relevance') and params['use_relevance'] == 'true'
          order_string += 'weight() DESC, '
        end
        order_string+= 'news_datetime DESC'

        if should_not_search
          result[:search_results] = [].paginate(:page => page, :per_page => per_page)
        else
          result[:search_results] = NewsItem.search(
              search_text,
              words: {
                  around: 0,
                  chunk_separator: ::Refinery::Books::WordsConverter::SEPARATOR,
                  before_match: ::Refinery::Books::WordsConverter::BEFORE_STRING,
                  after_match: ::Refinery::Books::WordsConverter::AFTER_STRING},
              page: page,
              per_page: per_page,
              with: with_hash,
              order: order_string,
              #match_mode: :extended
          )
          result[:search_results].context[:panes] << ThinkingSphinx::Panes::ExcerptsPane
          result[:search_results].context[:panes] << ::Refinery::Books::WordsPane
        end


        result

      end

    end
  end
end
