require 'zip'

class Page < ActiveRecord::Base

  belongs_to :book
  has_many :external_page_contents

  RESULTS_ON_PAGE = 20
  MAX_SEARCH_RESULTS = 1000
  PAGE_NAME_EXPORT_LIMIT = 30

  def self.zip_for_search(params, temp_file)

    params[:page] = 1
    search_results = sphinx_search(params, MAX_SEARCH_RESULTS)

    #Initialize the temp file as a zip file
    Zip::OutputStream.open(temp_file)  do |z|

      search_results[:search_results].each do |page|

        next if page.pdf_content.nil?
        title = page.short_book_and_page_name + '.pdf'
        z.put_next_entry(title)
        z.print(IO.read(File.expand_path(page.pdf_content.path)))

      end

    end


  end

  def short_book_and_page_name
    book_and_page_name.first(PAGE_NAME_EXPORT_LIMIT)
  end

  def book_and_page_name
    book.name + '. ' + display_name
  end

  def self.sphinx_search(params, results_per_page = nil)

    result = {}
    with_hash = {}
    search_text = params[:search_text]

    per_page = RESULTS_ON_PAGE
    per_page = results_per_page unless results_per_page.nil?
    per_page = params['per_page'].to_i if params.has_key?('per_page')

    search_text_array = search_text.split(' ').collect{ |x| x.strip }.select{|x| not x.empty?}
    if params.has_key?('search_exact_words') and params['search_exact_words'] == 'true'
      search_text_array = search_text_array.collect{ |x| "=#{x}" }
    end
    search_text = search_text_array.join(' | ')
    with_hash[:book_id] = params[:book_id] if params.has_key? :book_id
    #with_hash[:book_category_id] = params[:book_category_id] if params.has_key? :book_category_id

    result[:per_page] = per_page
    result[:count] = Page.search_count(search_text, with: with_hash)
    result[:too_many_results] = result[:count] >= MAX_SEARCH_RESULTS
    result[:show_snippets] = (params.has_key?(:show_snippets) and params[:show_snippets] == 'true')
    result[:book_category_ids] = Page.search(
        search_text,
        per_page: MAX_SEARCH_RESULTS,
        group_by: 'book_category_id'
    ).collect{|x| x.book.book_category_id}

    page = params[:page]
    if page.to_i*per_page > result[:count]
      page = (result[:count].to_f / per_page).ceil
    end

    order_string = ''
    unless params.has_key?('ignore_relevance') and params['ignore_relevance']
      order_string += 'weight() DESC, '
    end
    order_string+= 'book_id ASC, internal_order ASC'

    result[:search_results] = Page.search(
        search_text,
        words: {around: 0, chunk_separator: WordsConverter::SEPARATOR, before_match: '', after_match: ''},
        page: page,
        per_page: per_page,
        with: with_hash,
        order: order_string
    )
    result[:search_results].context[:panes] << ThinkingSphinx::Panes::ExcerptsPane
    result[:search_results].context[:panes] << WordsPane

    result

  end

  def pdf_content

    external_page_contents.find_by_content_type(ExternalPageContent::PDF_TYPE)

  end

  def html_content

    external_page_contents.find_by_content_type(ExternalPageContent::HTML_TYPE)

  end

  def prev

    Page.find_by_book_id_and_internal_order(book.id, internal_order - 1)

  end

  def next

    Page.find_by_book_id_and_internal_order(book.id, internal_order + 1)

  end

  def short_name

    I18n.t('importer.page') + ' ' + url_name

  end

  def display_name

    name = I18n.t('importer.page') + ' ' + url_name
    contents_element = book.get_parent_for_page(internal_order)

    return name if contents_element.nil? or contents_element.page_number != internal_order

    name += '. ' + contents_element.name
    name

  end

end
