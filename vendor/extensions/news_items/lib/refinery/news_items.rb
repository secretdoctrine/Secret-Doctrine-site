require 'refinerycms-core'

module Refinery
  autoload :NewsItemsGenerator, 'generators/refinery/news_items_generator'

  module NewsItems
    require 'refinery/news_items/engine'

    class << self
      attr_writer :root

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec', 'factories').to_s ]
      end
    end
  end
end
