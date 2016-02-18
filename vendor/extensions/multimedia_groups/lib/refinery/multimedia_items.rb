require 'refinerycms-core'

module Refinery
=begin
  autoload :MultimediaGroupsGenerator, 'generators/refinery/multimedia_groups_generator'

  module MultimediaItems
    require 'refinery/multimedia_items/engine'

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
=end
end
