module Refinery
  module Books
    class OrderableHelper

      def self.process_orderable(orderable_item, new_parent_id, old_parent_id, new_position, old_position)

        items_to_increase = []
        items_to_reduce = []

        new_parent = BookCategory.find(new_parent_id)
        old_parent = BookCategory.find(old_parent_id)

        if new_parent_id != old_parent_id

          items_to_increase = new_parent.children_array.select{|x| x.order_number >= new_position}
          items_to_reduce = old_parent.children_array.select{|x| x.order_number > old_position}

        else

          if new_position > old_position

            items_to_reduce = old_parent.children_array.select{|x| x.order_number > old_position and x.order_number <= new_position}

          elsif new_position < old_position

            items_to_increase = old_parent.children_array.select{|x| x.order_number >= new_position and x.order_number < old_position}

          end

        end


        ActiveRecord::Base.transaction do

          items_to_increase.each do |item|

            item.order_number += 1
            item.save

          end

          items_to_reduce.each do |item|

            item.order_number -= 1
            item.save

          end

          orderable_item.book_category_id = new_parent_id
          orderable_item.order_number = new_position

          orderable_item.save

        end

        ActiveRecord::Base.transaction do

          i = 0
          new_parent.children_array.sort_by{|x| x.order_number}.each do |child|

            child.order_number = i
            i += 1
            child.save

          end

          if new_parent_id != old_parent_id

            i = 0
            old_parent.children_array.sort_by{|x| x.order_number}.each do |child|

              child.order_number = i
              i += 1
              child.save

            end

          end

        end

      end
    end
  end
end
