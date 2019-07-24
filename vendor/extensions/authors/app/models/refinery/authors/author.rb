module Refinery
  module Authors
    class Author < Refinery::Core::BaseModel
      extend FriendlyId
        friendly_id :friendly_header, :use => [:slugged]
      self.table_name = 'refinery_authors'

      ROOT_NAME = ::I18n.t('authors.root_name')

      has_many :poems
      has_many :authors
      belongs_to :author

      validates :name, :presence => true, :uniqueness => true

      SHORT_NAME_LIMIT = 80

      def short_name
        return name if name.length < SHORT_NAME_LIMIT
        name.first(SHORT_NAME_LIMIT) + '(...)'
      end


      def should_generate_new_friendly_id?
        changes.keys.include? 'friendly_header'
      end

      def destroy
        authors.each {|x| x.destroy}
        poems.each {|x| x.destroy}
        super
      end

      def get_next_order_number

        last_child = children_array.sort_by{|x| x.order_number}.last

        return 0 if last_child.nil?
        last_child.order_number + 1

      end

      def parent_id=(new_id)
        self.multimedia_group_id = new_id
      end

      def self.get_root!

        root = find_by(is_root: true)
        if root.nil?
          authors = Author.where(:author_id => nil).to_a
          root = create!(name: ROOT_NAME, is_root: true, order_number: 0)
          authors.each do |group|
            group.author_id = root.id
            group.save!
          end
        end
        root

      end

      def children_array

        result = []
        authors.each {|x| result.push(x)}
        poems.each {|x| result.push(x)}

        result.sort_by {|x| x.order_number}

      end

      def update_position(new_parent_id, old_parent_id, new_position, old_position)

        Refinery::Books::OrderableHelper.process_orderable(self, new_parent_id, old_parent_id, new_position, old_position, Author)

      end

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
