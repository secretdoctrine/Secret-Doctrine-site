require 'fileutils'
require 'rake'

module Refinery
  module Books

    class Importer

      BOOK_IMPORT_NAME_LIMIT = 120

      def self.working_directory

        File.join(Rails.root, 'public')

      end

      def self.books_to_load

        result = []
        upload_directory = File.join(working_directory, 'Upload')

        subdirectories = Dir.entries(upload_directory).select {
            |entry| File.directory? File.join(upload_directory,entry) and !(entry =='.' || entry == '..')
        }.collect {|x| File.join(upload_directory, x)}

        subdirectories.each do |dir|
          yamls = Dir.glob(File.join(dir, '*.yml'))
          yamls.each do |yaml|

            string = ''

            next unless is_loadable_path(yaml)
            yaml_object = YAML.load(File.read(yaml))

            if yaml_object['book'].has_key? 'name_prefix' and yaml_object['book']['name_prefix']
              string += yaml_object['book']['name_prefix'] + ' '
            end
            string += yaml_object['book']['name']
            if yaml_object['book'].has_key? 'name_comment' and yaml_object['book']['name_comment']
              string += ' ' + yaml_object['book']['name_comment']
            end
            string += ' (' + yaml.sub(working_directory.to_s, "") + ')'

            if string.length > BOOK_IMPORT_NAME_LIMIT
              string = string.first(BOOK_IMPORT_NAME_LIMIT) + '(...)'
            end

            result.push([string, yaml.sub(working_directory.to_s, "")])
          end
        end

        result

      end

      def self.validate_yaml(yaml_object)

        return false unless yaml_object.has_key? 'pdf_regex'
        return false unless yaml_object.has_key? 'html_regex'
        return false unless yaml_object.has_key? 'book'

        return false unless yaml_object['book'].has_key? 'first_page'
        return false unless yaml_object['book'].has_key? 'first_page'
        return false unless yaml_object['book'].has_key? 'contents'

        return false unless yaml_object['book']['contents'].any?

        yaml_object['book']['contents'].each do |content_element|

          return false unless content_element.has_key? 'name'
          return false unless content_element.has_key? 'page'
          return false unless content_element.has_key? 'type'

          return false unless [ContentsElement::SECTION_CE_TYPE_NAME,
                               ContentsElement::CHAPTER_CE_TYPE_NAME,
                               ContentsElement::PART_CE_TYPE_NAME,
                               ContentsElement::PAGE_CE_TYPE_NAME].include? content_element['type']

        end

        return true

      end

      def self.create_directory

        dir = FileUtils::mkdir_p(File.join(working_directory, "Storage/#{Time.now.strftime("%Y-%m-%d-%H-%M-%S-%6N")}"))
        dir.first

      end

      def self.to_roman_lower(number)

        return to_roman(number).downcase

      end

      def self.to_roman(number)

        reductions = {
            1000 => 'M',
            900 => 'CM',

            500 => 'D',
            400 => 'CD',

            100 => 'C',
            90 => 'XC',

            50 => 'L',
            40 => 'XL',

            10 => 'X',
            9 => 'IX',

            5 => 'V',
            4 => 'IV',

            1 => 'I',
        }

        result = ''

        while number > 0
          reductions.each do |n, subst|
            if number / n >= 1 # if number contains at least one of n
              result << subst  # push corresponding symbol to result
              number -= n
              break            # break from each and start it anew
              # so that the largest numbers are checked first again.
            end
          end
        end

        result

      end

      def self.transaction_import(yaml_object, book_category_id, full_yaml_path, order_number, dest_directory, result)

        source_dir_name = File.dirname(full_yaml_path)

        result[:book].name = yaml_object['book']['name']
        result[:book].page_count = yaml_object['book']['page_count'].to_i
        result[:book].order_number = order_number
        result[:book].book_category_id = book_category_id
        result[:book].synopsis = yaml_object['book']['synopsis'] if yaml_object['book'].has_key? 'synopsis'
        result[:book].name_prefix = yaml_object['book']['name_prefix'] if yaml_object['book'].has_key? 'name_prefix'
        result[:book].tree_prefix = yaml_object['book']['tree_prefix'] if yaml_object['book'].has_key? 'tree_prefix'
        result[:book].name_comment =
            yaml_object['book']['name_comment'] if yaml_object['book'].has_key? 'name_comment'
        result[:book].can_buy =
            yaml_object['book'].has_key?('can_buy') ? yaml_object['book']['can_buy'] == 'true' : false
        result[:book].local_path = Pathname.new(dest_directory).relative_path_from(Rails.root)

        result[:book].save!

        if yaml_object['book'].has_key?('picture_path')
          result[:book].cover_picture = ::Refinery::Image.new
          result[:book].cover_picture.image = File.open(File.join(source_dir_name, yaml_object['book']['picture_path']))
          result[:book].cover_picture.save
          result[:book].save!
        end

        if yaml_object['book'].has_key?('book_file')
          result[:book].book_file = ::Refinery::Resource.new
          result[:book].book_file.file = File.open(File.join(source_dir_name, yaml_object['book']['book_file']))
          result[:book].book_file.save!
          result[:book].save!
        end

        yaml_object['book']['contents'].each do |content_element|

          ContentsElement.create!(
              name: content_element['name'],
              book_id: result[:book].id,
              page_number: content_element['page'].to_i,
              ce_type: ContentsElement.type_name_to_ce_type(content_element['type']),
              name_comment: content_element.has_key?('name_comment') ? content_element['name_comment'] : nil,
              name_prefix: content_element.has_key?('name_prefix') ? content_element['name_prefix'] : nil,
          )

        end

        min_page = yaml_object['book']['first_page'].to_i
        page_count = yaml_object['book']['page_count'].to_i

        dir_entries = Dir.entries(source_dir_name)

        pdf_regex = /#{yaml_object['pdf_regex']}/
        html_regex = /#{yaml_object['html_regex']}/

        (min_page..(min_page + page_count - 1)).each do |page_num|

          file_page_num = page_num + (1 - min_page)

          if page_num <= 0

            selector = yaml_object['book'].has_key? 'negative_numeration' ?
                                                        yaml_object['book']['negative_numeration'] :
                                                        'roman_upper'
            if selector == 'roman_lower'
              url_name = to_roman_lower(page_num - (min_page - 1))
            else
              url_name = to_roman(page_num - (min_page - 1))
            end

          else
            url_name = page_num.to_s
          end



          page = BookPage.create!(book_id: result[:book].id, internal_order: page_num, url_name: url_name, page_text: '')

          pdf_file_name = dir_entries.find{|x| pdf_regex.match(x) and pdf_regex.match(x)[1].to_i == file_page_num}
          if pdf_file_name.nil?
            result[:message] = ::I18n.t('importer.no_pdf_file') + ' ' + file_page_num.to_s
            return result
          end

          FileUtils.cp(File.join(source_dir_name, pdf_file_name), File.join(dest_directory, pdf_file_name))
          ExternalPageContent.create!(
              book_page_id: page.id,
              content_type: ExternalPageContent::PDF_TYPE,
              path: Pathname.new(File.join(dest_directory, pdf_file_name)).relative_path_from(Rails.root))

          dir_entries.delete(pdf_file_name)

          html_file_name = dir_entries.find{|x| html_regex.match(x) and html_regex.match(x)[1].to_i == file_page_num}
          if html_file_name.nil?
            result[:message] = ::I18n.t('importer.no_html_file') + ' ' + file_page_num.to_s
            return result
          end

          FileUtils.cp(File.join(source_dir_name, html_file_name), File.join(dest_directory, html_file_name))
          ExternalPageContent.create!(
              book_page_id: page.id,
              content_type: ExternalPageContent::HTML_TYPE,
              path: Pathname.new(File.join(dest_directory, html_file_name)).relative_path_from(Rails.root))

          content = Nokogiri::HTML(File.read(File.join(dest_directory, html_file_name)))
          content.css('style,script').remove
          page.page_text = content.text
          page.save!

          dir_entries.delete(html_file_name)

        end

        result[:success] = true

      end

      def self.import_yaml(book, yaml_path, book_category_id, order_number)

        result = {:success => false, :book => book, :message => ''}
        full_yaml_path = File.join(working_directory, yaml_path)

        if BookCategory.find_by_id(book_category_id).nil?
          result[:message] = ::I18n.t('importer.invalid_book_category')
          return result
        end

        unless is_loadable_path(full_yaml_path)
          result[:message] = ::I18n.t('importer.invalid_config_file')
          return result
        end

        yaml_object = YAML.load(File.read(full_yaml_path))

        dest_directory = self.create_directory
        unless dest_directory
          result[:message] = ::I18n.t('importer.unable_to_create_dir')
          return result
        end


        begin
          ActiveRecord::Base.transaction do
            if result[:book].id
              result[:book].destroy
              result[:book] = Book.new
            end
            transaction_import(yaml_object, book_category_id, full_yaml_path, order_number, dest_directory, result)
            raise Exception.new(result[:message]) unless result[:success]
          end
        rescue Exception => e

          FileUtils.rm_r dest_directory
          result[:message] = e.message
          return result

        end

        spec = Gem::Specification.find_by_name('thinking-sphinx')
        load("#{spec.gem_dir}/lib/thinking_sphinx/tasks.rb")
        Rake::Task['ts:index'].execute

        result

      end

      def self.is_loadable_path(path)

        begin

          yaml_object = YAML.load(File.read(path))
          return self.validate_yaml(yaml_object)

        rescue Exception => e
          return false
        end

      end

    end
  end
end