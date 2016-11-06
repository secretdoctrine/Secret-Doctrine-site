module Refinery
  module Books
    class Book < Refinery::Core::BaseModel

      SHORT_NAME_LIMIT = 80

      FORMAT_UNLIM = 0
      FORMAT_700_950 = 1
      FORMAT_950_1350 = 2
      FORMAT_750_1100 = 3
      FORMAT_600_900 = 4
      FORMAT_700_960 = 5
      FORMAT_650_900 = 6


      def export_yml

        result = ""
        result += "pdf_regex: \n"
        result += "html_regex: \n"
        result += "book:\n"
        result += "  picture_path:\n"
        result += "  book_file:\n"
        result += "  name_prefix: '" + self.name_prefix + "'\n"
        result += "  tree_prefix: '" + self.tree_prefix + "'\n"
        result += "  name: '" + self.name + "'\n"
        result += "  name_comment: '" + self.name_comment + "'\n"
        result += "  page_count: '" + self.book_pages.count.to_s + "'\n"
        result += "  first_page: '" + self.book_pages.sort_by{|x| x.internal_order}.first.internal_order.to_s + "'\n"
        result += "  synopsis: '" + self.synopsis + "'\n"
        result += "  contents:\n"

        contents_elements.sort_by{|x| x.page_number}.each do |ce|

          result += "  "*2 + "- \n"
          result += "  "*3 + "name: '" + ce.name + "'\n"
          result += "  "*3 + "page: '" + ce.page_number.to_s + "'\n"
          result += "  "*3 + "type: '" + ce.get_class_name + "'\n"
          result += "  "*3 + "name_prefix: '" + ce.name_prefix + "'\n" unless ce.name_prefix.blank?
          result += "  "*3 + "name_comment: '" + ce.name_comment + "'\n" unless ce.name_comment.blank?

        end

        result

      end


      def html_width

        return 0 if self.page_format == FORMAT_UNLIM
        return 700 if self.page_format == FORMAT_700_950
        return 950 if self.page_format == FORMAT_950_1350
        return 750 if self.page_format == FORMAT_750_1100
        return 600 if self.page_format == FORMAT_600_900
        return 700 if self.page_format == FORMAT_700_960
        return 650 if self.page_format == FORMAT_650_900

        0

      end

      def html_height

        return 0 if self.page_format == FORMAT_UNLIM
        return 950 if self.page_format == FORMAT_700_950
        return 1350 if self.page_format == FORMAT_950_1350
        return 1100 if self.page_format == FORMAT_750_1100
        return 900 if self.page_format == FORMAT_600_900
        return 960 if self.page_format == FORMAT_700_960
        return 900 if self.page_format == FORMAT_650_900

        0

      end

      def page_format_array_for_select
        [
            [::I18n.t('library.format_unlim'), FORMAT_UNLIM],
            [::I18n.t('library.format_700_950'), FORMAT_700_950],
            [::I18n.t('library.format_950_1350'), FORMAT_950_1350],
            [::I18n.t('library.format_750_1100'), FORMAT_750_1100],
            [::I18n.t('library.format_600_900'), FORMAT_600_900],
            [::I18n.t('library.format_700_960'), FORMAT_700_960],
            [::I18n.t('library.format_650_900'), FORMAT_650_900]]
      end

      def short_name
        return name if name.length < SHORT_NAME_LIMIT
        name.first(SHORT_NAME_LIMIT) + '(...)'
      end


      def parent_id=(new_id)
        self.book_category_id = new_id
      end

      def destroy
        begin
          if local_path.start_with?("public")
            FileUtils.rm_r(File.join(Rails.root, local_path))
          end
        rescue
        end
        super
      end

      self.table_name = 'refinery_books'

      validates :name, :presence => true#, :uniqueness => true

      has_many :book_pages
      has_many :contents_elements
      has_many :external_book_contents
      belongs_to :book_category

      belongs_to :cover_picture, :class_name => '::Refinery::Image'
      belongs_to :book_file, :class_name => '::Refinery::Resource'

      def update_position(new_parent_id, old_parent_id, new_position, old_position)

        OrderableHelper.process_orderable(self, new_parent_id, old_parent_id, new_position, old_position, BookCategory)

      end

      def pdf_content

        external_book_contents.find_by_content_type(ExternalBookContent::PDF_TYPE)

      end

      def add_contents_element(tree_parent, db_element, page)

        parent_for_page = page ? get_parent_for_page(page.internal_order) : nil
        target_page = BookPage.find_by_book_id_and_internal_order(db_element.book.id, db_element.page_number)

        tree_element = ContentsTreeElement.new(
            selected: (parent_for_page and parent_for_page.id == db_element.id),
            display_name: db_element.name,
            book_id: db_element.book.id,
            page_internal_number: target_page ? target_page.url_name : nil,
            class_name: db_element.get_class_name,
            name_prefix: db_element.name_prefix,
            name_comment: db_element.name_comment
        )

        db_element.contents_elements.sort_by{ |x| x.page_number }.each {
            |x| add_contents_element(tree_element, x, page)
        }

        tree_parent.child_elements.push(tree_element)

      end

      def pages_for_select

        book_pages.sort_by{ |page| page.internal_order }.collect{ |page| [page.url_name, page.url_name] }

      end

      def sorted_content_elements
        contents_elements.sort_by{|x| [x.page_number, x.get_nest_level, x.id]}
      end

      def build_contents(page)

        root_element = ContentsTreeElement.new

        #contents_elements.where(contents_element_id: nil).sort_by{ |x| x.page_number }.each do |content_element|
        sorted_content_elements.each do |content_element|
          add_contents_element(root_element, content_element, page)
        end

        root_element

      end

      def get_parent_for_content_element(content_element)

        element = contents_elements.select{|x| x.page_number <= content_element.page_number and x.bigger_content_element_than_provided(content_element)}
            .sort_by{|x| [-x.page_number, -x.get_nest_level]}.first
        element

      end

      def get_parent_for_page(page_num)

        preceding_elements = contents_elements.select{|x| x.page_number <= page_num}
        return nil if preceding_elements.empty?
        max_named_page = preceding_elements.max_by{|x| x.page_number}.page_number

        element = contents_elements.select{|x| x.page_number == max_named_page}.sort_by{|x| -x.get_nest_level}.first
        element

      end

      def get_nearest_non_page_content_element_for_page(page_num)

        element = contents_elements.select{|x| x.page_number <= page_num and x.ce_type != ContentsElement::PAGE_CE_TYPE}.sort_by{|x| [-x.page_number, -x.get_nest_level]}.first
        element

      end

      def get_non_page_parent_for_page(page_num)

        preceding_elements = contents_elements.select{|x| x.page_number <= page_num}
        return nil if preceding_elements.empty?
        max_named_page = preceding_elements.max_by{|x| x.page_number}.page_number

        element =
            contents_elements
              .select{|x| x.page_number == max_named_page and x.get_nest_level != ContentsElement::PAGE_CE_TYPE}
              .sort_by{|x| -x.get_nest_level}
              .first
        element

      end

      def breadcrumb_parents

        parents = []

        parent = book_category
        root = BookCategory.get_root!
        while parent.id != root.id
          doc = Nokogiri::HTML(parent.name)
          stripped_name = doc.xpath("//text()").text
          parents.unshift({
                              :prefix => parent.tree_prefix,
                              :name => stripped_name,
                              :link_target => Refinery::Core::Engine.routes.url_helpers.books_book_category_path(parent.id),
                              :is_book => false
                          })
          parent = parent.book_category
        end

        parents

      end

    end
  end
end
