module Refinery
  module Books
    class WordsPane

      def initialize(context, object, raw)
        @context, @object = context, object
      end

      def words
        @words_glazing ||= Excerpts.new @object, excerpter
      end

      private

      def excerpter
        @excerpter ||= ThinkingSphinx::Excerpter.new(
            @context[:indices].first.name,
            excerpt_words,
            @context.search.options[:words] || {}
        )
      end

      def excerpt_words
        @excerpt_words ||= begin
          conditions = @context.search.options[:conditions] || {}
          ThinkingSphinx::Search::Query.new(
              ([@context.search.query] + conditions.values).compact.join(' '),
              {}, @context.search.options[:star]
          ).to_s
        end
      end

      class Excerpts
        def initialize(object, excerpter)
          @object, @excerpter = object, excerpter
        end

        private

        def method_missing(method, *args, &block)
          @excerpter.excerpt! @object.send(method, *args, &block).to_s
        end
      end

    end
  end
end