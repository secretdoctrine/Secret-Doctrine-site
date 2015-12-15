

module BookHelper

  class BookImportHelper

    attr_accessor :page_selector, :pdf_regex, :html_regex, :files_path, :shift_modifier, :book_structure, :pages_dictionary

    def initialize(page_selector, pdf_regex, html_regex, files_path, shift_modifier, book_structure, pages_dictionary)

      @page_selector = page_selector
      @pdf_regex = pdf_regex
      @html_regex = html_regex
      @files_path = files_path
      @shift_modifier = shift_modifier
      @book_structure = book_structure
      @pages_dictionary = pages_dictionary

    end

  end



  class Importer

    def int_value(string_value)

      string_value.sub('~', '-').to_i

    end

    def create_part(book, part, parent)

      ContentsElement.create!(
          name: part['name'],
          book_id: book.id,
          page_number: min_part_page(part),
          content_element_id: parent.nil? ? nil : parent.id)

    end

    def create_chapter(book, chapter)

      created_chapter = ContentsElement.create!(
          name: chapter['name'],
          book_id: book.id,
          page_number: min_chapter_page(chapter),
          content_element_id: nil)
      if chapter['parts']
        chapter['parts'].each { |part| create_part(book, part, created_chapter) }
      end

    end

    def import_yaml(yaml_object, number, category)

      book = Book.create!(
          name: yaml_object['book']['name'],
          order_number: number,
          book_category_id: category.id,
          synopsis: yaml_object['book']['synopsis'])

      if yaml_object['book']['parts']
        yaml_object['book']['parts'].each { |part| create_part(book, part, nil) }
      end
      if yaml_object['book']['chapters']
        yaml_object['book']['chapters'].each { |chapter| create_chapter(book, chapter) }
      end

      (min_book_page(yaml_object['book'])..max_book_page(yaml_object['book'])).each do |page_num|

        file_page_num = page_num + yaml_object['shift_modifier'].to_i
        named_page = yaml_object['pages_dictionary'].find{ |x| x['page'].to_i == page_num }
        page_name = named_page.nil? ? 'Page ' + page_num.to_s : named_page['name']

        page = Page.create!(book_id: book.id, internal_order: page_num, display_name: page_name)
        Dir.entries(File.expand_path(yaml_object['files_path'])).each do |file_name|

          match = /#{yaml_object['pdf_regex']}/.match(file_name)
          unless match.nil?
            match_num = match[1].to_i
            if match_num == file_page_num
              ExternalPageContent.create!(
                  page_id: page.id,
                  content_type: ExternalPageContent::PDF_TYPE,
                  path: File.join(File.expand_path(yaml_object['files_path']), file_name))
            end
          end

          match = /#{yaml_object['html_regex']}/.match(file_name)
          unless match.nil?
            match_num = match[1].to_i
            if match_num == file_page_num
              ExternalPageContent.create!(
                  page_id: page.id,
                  content_type: ExternalPageContent::HTML_TYPE,
                  path: File.join(File.expand_path(yaml_object['files_path']), file_name))
            end
          end

        end

      end

    end

    def import_all

      ActiveRecord::Base.transaction do

        root_category = BookCategory.get_root!

        td1 = YAML.load(File.read("#{Rails.root}/db/configs/td1.yml"))
        import_yaml(td1, 0, root_category)

        td2 = YAML.load(File.read("#{Rails.root}/db/configs/td2.yml"))
        import_yaml(td2, 1, root_category)

        subcategory1 = BookCategory.create!(name: 'Subcategory 1', book_category_id: root_category.id, order_number: 0)

        td3 = YAML.load(File.read("#{Rails.root}/db/configs/td3.yml"))
        import_yaml(td3, 0, subcategory1)

      end

    end

    def min_part_page(part)

      min_page = 0
      min_page = int_value(part['pages'].split('-')[0]) unless part['pages'].nil?

      min_page

    end

    def min_chapter_page(chapter)

      min_page = 0
      min_page = int_value(chapter['pages'].split('-')[0]) unless chapter['pages'].nil?

      if chapter['parts']
        chapter['parts'].each { |part| min_page = min_part_page(part) if min_page > min_part_page(part) }
      end

      min_page

    end

    def min_book_page(book)

      min_page = 0
      min_page = int_value(book['pages'].split('-')[0]) unless book['pages'].nil?

      if book['chapters']
        book['chapters'].each { |chapter| min_page = min_chapter_page(chapter) if min_page > min_chapter_page(chapter) }
      end
      if book['parts']
        book['parts'].each { |part| min_page = min_part_page(part) if min_page > min_part_page(part) }
      end

      min_page

    end

    def max_part_page(part)

      max_page = 0
      max_page = int_value(part['pages'].split('-')[1]) unless part['pages'].nil?

      max_page

    end

    def max_chapter_page(chapter)

      max_page = 0
      max_page = int_value(chapter['pages'].split('-')[1]) unless chapter['pages'].nil?

      if chapter['parts']
        chapter['parts'].each { |part| max_page = max_part_page(part) if max_page < max_part_page(part) }
      end

      max_page

    end

    def max_book_page(book)

      max_page = 0
      max_page = int_value(book['pages'].split('-')[1]) unless book['pages'].nil?

      if book['chapters']
        book['chapters'].each { |chapter| max_page = max_chapter_page(chapter) if max_page < max_chapter_page(chapter) }
      end
      if book['parts']
        book['parts'].each { |part| max_page = max_part_page(part) if max_page < max_part_page(part) }
      end

      max_page

    end

  end

end
