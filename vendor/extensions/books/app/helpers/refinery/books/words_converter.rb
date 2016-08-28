module Refinery
  module Books
    class WordsConverter

      SEPARATOR = '||||||***||||||'
      BEFORE_STRING = 'XXXXXAAAXXXXX'
      AFTER_STRING = 'XXXXXBBBXXXXX'

      def self.convert(str)

        results_array = []

        str.split(SEPARATOR).collect{|x| x.strip}.select{|x| x.length > 0}.each do |x|
          results_array += x.scan(Regexp.new(BEFORE_STRING + '(.+?)' + AFTER_STRING))
        end

        result = '(' +
            results_array.join('|') +
            ')'
        result

      end

    end
  end
end