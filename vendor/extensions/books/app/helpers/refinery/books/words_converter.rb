module Refinery
  module Books
    class WordsConverter

      SEPARATOR = '||||||***||||||'
      BEFORE_STRING = 'XXXXXAAAXXXXX'
      AFTER_STRING = 'XXXXXBBBXXXXX'

      def self.convert(str)

        result = '(' +
            str.split(SEPARATOR).collect{|x| x.strip}.select{|x| x.length > 0}
                .collect{|x| Regexp.new(BEFORE_STRING + '(.+)' + AFTER_STRING).match(x)[1]}
                .uniq.join('|') +
            ')'
        result

      end

    end
  end
end