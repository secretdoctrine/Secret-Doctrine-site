require 'will_paginate/array'
module Refinery
  module Books
    require 'zip'

    class BookPage < Refinery::Core::BaseModel

      belongs_to :book
      has_many :external_page_contents

      RESULTS_ON_PAGE = 10
      MAX_SEARCH_RESULTS = 1000
      PAGE_NAME_EXPORT_LIMIT = 30
      BOOK_NAME_EXPORT_LIMIT = 30
      NAME_SEPARATOR = ' / '

      def numeric_name

        first_page_number = self.book.book_pages.sort_by { |p| p.internal_order }.first.internal_order
        name = '%04d' % (internal_order - first_page_number + 1)

      end

      def zip_export(temp_file)

        name = numeric_name

        Zip::OutputStream.open(temp_file)  do |z|

          if pdf_content
            title = name + '.pdf'
            z.put_next_entry(title)
            z.print(IO.read(File.expand_path(File.join(Rails.root, pdf_content.path))))
          end
          if html_content
            title = name + '.html'
            z.put_next_entry(title)
            z.print(IO.read(File.expand_path(File.join(Rails.root, html_content.path))))
          end

        end

      end

      def self.zip_for_search(params, temp_file)

        params[:page] = 1
        search_results = sphinx_search(params, MAX_SEARCH_RESULTS)

        #Initialize the temp file as a zip file
        Zip::OutputStream.open(temp_file)  do |z|

          search_results[:search_results].each do |page|

            #next if page.pdf_content.nil?
            if page.pdf_content
              title = page.short_book_and_page_name + '.pdf'
              z.put_next_entry(title)
              z.print(IO.read(File.expand_path(File.join(Rails.root, page.pdf_content.path))))
            else
              title = page.short_book_and_page_name + '.html'
              z.put_next_entry(title)
              z.print(IO.read(File.expand_path(File.join(Rails.root, page.html_content.path))))
            end


          end

        end


      end

      def short_book_and_page_name
        #book_and_page_name.first(PAGE_NAME_EXPORT_LIMIT)
        result = book.name.first(BOOK_NAME_EXPORT_LIMIT)
        if book.name.length > BOOK_NAME_EXPORT_LIMIT
          result += '(...)'
        end
        result += ' - ' + display_name.first(PAGE_NAME_EXPORT_LIMIT)
        if display_name.length > PAGE_NAME_EXPORT_LIMIT
          result += '(...)'
        end

        result
      end

      def book_and_page_name
        book.name + '. ' + display_name
      end

      def self.make_tree(selected_book_ids, selected_category_ids)

        tree = BookCategory.build_categories_tree(
            selected_book_ids: selected_book_ids,
            selected_category_ids: selected_category_ids)
        tree

      end

      def self.sphinx_search(params, results_per_page = nil)

        result = {}
        with_hash = {}
        search_text = (params[:search_text] or '')

        show_extended_search = (params.has_key?('is_ext_search') and params['is_ext_search'] == 'true')
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

        selected_book_ids = []
        selected_category_ids = []
        use_tree_selected = true

        if params.has_key? :book_category_id

          use_tree_selected = false
          category = BookCategory.find_by_id(params[:book_category_id])
          #selected_category_ids = category.categories_array
          selected_book_ids += category.all_child_book_ids
          #with_hash[:book_category_id] = selected_category_ids
          with_hash[:book_id] = selected_book_ids

        end

        if params.has_key? :book_id

          use_tree_selected = false
          selected_book_ids = [params['book_id'].to_i]
          with_hash[:book_id] = selected_book_ids

        end

        if use_tree_selected and params.has_key?('tree_selected')

          params['tree_selected'].split(', ').each do |selected_element|

            split_element = selected_element.split('#')
            if split_element[0] == TreeElement::BOOK_TYPE
              selected_book_ids.push(split_element[1].to_i)
            end

            if split_element[0] == TreeElement::CATEGORY_TYPE
              category_id = split_element[1].to_i
              selected_category_ids.push(category_id)

              category = BookCategory.find_by_id(category_id)

              next if category.nil?

              if category.id == BookCategory.get_root!.id
                selected_category_ids.clear
                selected_book_ids.clear
                break
              end

              selected_book_ids += category.all_child_book_ids

            end

          end

        end

        # to make displayed tree not empty
        #if selected_book_ids.empty? and selected_category_ids.empty?
        #  #selected_category_ids.push(BookCategory.get_root!.id)
        #  selected_book_ids += BookCategory.get_root!.all_child_book_ids
        #end

        selected_book_ids.uniq!

        if use_tree_selected
          with_hash[:book_id] = selected_book_ids if selected_book_ids.any?
        end
        #with_hash[:book_category_id] = selected_category_ids if selected_category_ids.any?

        #result[:tree_selected] = selected_book_ids.join(', ')

        result[:tree] = make_tree(selected_book_ids, selected_category_ids)
        result[:per_page] = per_page

        should_not_search = (show_extended_search or search_text.empty?)
        result[:should_not_search] = should_not_search

        if should_not_search
          result[:count] = 0
        else
          result[:count] = BookPage.search_count(search_text, with: with_hash)
        end
        result[:too_many_results] = result[:count] >= MAX_SEARCH_RESULTS
        result[:show_html] = (params.has_key?(:show_html) and params[:show_html] == 'true')

        if should_not_search
          result[:book_category_ids] = []
        else
          result[:book_category_ids] = BookPage.search(
              search_text,
              per_page: MAX_SEARCH_RESULTS,
              group_by: 'book_category_id'
          ).collect{|x| x.book.book_category_id}
        end

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
        order_string+= 'book_id ASC, internal_order ASC'

        if should_not_search
          result[:search_results] = [].paginate(:page => page, :per_page => per_page)
        else
          result[:search_results] = BookPage.search(
              search_text,
              words: {
                  around: 0,
                  chunk_separator: WordsConverter::SEPARATOR,
                  before_match: WordsConverter::BEFORE_STRING,
                  after_match: WordsConverter::AFTER_STRING},
              page: page,
              per_page: per_page,
              with: with_hash,
              order: order_string
          )
          result[:search_results].context[:panes] << ThinkingSphinx::Panes::ExcerptsPane
          result[:search_results].context[:panes] << WordsPane
        end


        result

      end

      def pdf_content

        external_page_contents.find_by_content_type(ExternalPageContent::PDF_TYPE)

      end

      def html_content

        external_page_contents.find_by_content_type(ExternalPageContent::HTML_TYPE)

      end

      def prev

        BookPage.find_by_book_id_and_internal_order(book.id, internal_order - 1)

      end

      def next

        BookPage.find_by_book_id_and_internal_order(book.id, internal_order + 1)

      end

      def short_name

        ::I18n.t('importer.page') + ' ' + url_name

      end

      def display_name

        name = ::I18n.t('importer.page') + ' ' + url_name
        contents_element = book.get_parent_for_page(internal_order)

        if contents_element.nil? or contents_element.page_number != internal_order or contents_element.ce_type != ContentsElement::PAGE_CE_TYPE
          return name
        end

        name += '. ' + contents_element.name
        name += ' ' + contents_element.name_comment unless contents_element.name_comment.blank?
        name.html_safe

      end

      def display_name_page_only

        name = ::I18n.t('importer.page') + ' ' + url_name
        contents_element = book.get_parent_for_page(internal_order)

        return name if contents_element.nil? or contents_element.page_number != internal_order or contents_element.ce_type != ContentsElement::PAGE_CE_TYPE

        name += '. ' + contents_element.name
        name += ' ' + contents_element.name_comment unless contents_element.name_comment.blank?
        name.html_safe

      end

      def full_path_name

        parents = []
        parent = book.get_non_page_parent_for_page(internal_order)

        #while parent
        #  parents.unshift(parent)
        #  parent = parent.contents_element
        #end
        parents.unshift(parent) if parent

        full_name = book.name + NAME_SEPARATOR
        full_name += parents.collect{|x| x.name}.join(NAME_SEPARATOR)
        full_name += NAME_SEPARATOR if parents.any?
        full_name += display_name_page_only

        full_name.html_safe

      end

      def breadcrumb_parents

        parents = []
        parent = book.get_nearest_non_page_content_element_for_page(internal_order)

        while parent
          target_page = BookPage.find_by_book_id_and_internal_order(book.id, parent.page_number)
          doc = Nokogiri::HTML(parent.name)
          striped_name = doc.xpath("//text()").text
          parents.unshift({
                              :prefix => parent.name_prefix,
                              :name => striped_name,
                              :comment => parent.name_comment,
                              :link_target => Refinery::Core::Engine.routes.url_helpers.books_book_page_path(book.id, target_page.id),
                              :is_book => false
                          })
          parent = book.get_parent_for_content_element(parent)
        end

        doc = Nokogiri::HTML(book.name)
        striped_name = doc.xpath("//text()").text
        parents.unshift({
                            :prefix => book.name_prefix,
                            :name => striped_name,
                            :comment => book.name_comment,
                            :link_target => Refinery::Core::Engine.routes.url_helpers.books_book_path(book.id),
                            :is_book => true
                        })

        parents = book.breadcrumb_parents + parents

        parents

      end

    end
  end
end