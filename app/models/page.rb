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

  def self.sphinx_search(params, results_per_page = RESULTS_ON_PAGE)


    #@search_results = Page.search(params[:search_text], :excerpts => {
    #                                                      :around => 0, :chunk_separator => '|', :before_match => '', :after_match => ''})
    result = {}
    with_hash = {}
    with_hash[:book_id] = params[:book_id] if params.has_key? :book_id
    #with_hash[:book_category_id] = params[:book_category_id] if params.has_key? :book_category_id

    result[:count] = Page.search_count(params[:search_text], with: with_hash)
    result[:too_many_results] = result[:count] >= MAX_SEARCH_RESULTS
    result[:show_html] = (params.has_key?(:show_html) and params[:show_html] == 'true')
    result[:book_category_ids] = Page.search(
        params[:search_text],
        per_page: MAX_SEARCH_RESULTS,
        group_by: 'book_category_id'
    ).collect{|x| x.book.book_category_id}

    page = params[:page]
    if page.to_i*RESULTS_ON_PAGE > result[:count]
      page = (result[:count].to_f / RESULTS_ON_PAGE).ceil
    end


    result[:search_results] = Page.search(
        params[:search_text],
        words: {around: 0, chunk_separator: WordsConverter::SEPARATOR, before_match: '', after_match: ''},
        page: page,
        per_page: results_per_page,
        with: with_hash,
        order: 'weight() DESC, book_id ASC, internal_order ASC'
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
