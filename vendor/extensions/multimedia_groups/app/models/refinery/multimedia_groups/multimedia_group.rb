module Refinery
  module MultimediaGroups
    class MultimediaGroup < Refinery::Core::BaseModel
      belongs_to :multimedia_group
      has_many :multimedia_groups
      has_many :multimedia_items
      self.table_name = 'refinery_multimedia_groups'

      ROOT_NAME = ::I18n.t('multimedia_groups.root_name')


      validates :title, :presence => true, :uniqueness => true

      def destroy
        multimedia_groups.each {|x| x.destroy}
        multimedia_items.each {|x| x.destroy}
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
          @multimedia_groups = MultimediaGroup.where(:multimedia_group_id => nil).to_a
          root = create!(title: ROOT_NAME, is_root: true, order_number: 0)
          @multimedia_groups.each do |group|
            group.multimedia_group_id = root.id
            group.save!
          end
        end
        root

      end

      def children_array

        result = []
        multimedia_groups.each {|x| result.push(x)}
        multimedia_items.each {|x| result.push(x)}

        result.sort_by {|x| x.order_number}

      end

      def update_position(new_parent_id, old_parent_id, new_position, old_position)

        Refinery::Books::OrderableHelper.process_orderable(self, new_parent_id, old_parent_id, new_position, old_position, MultimediaGroup)

      end

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
