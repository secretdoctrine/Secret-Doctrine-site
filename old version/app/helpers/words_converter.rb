class WordsConverter

  SEPARATOR = '||||||***||||||'

  def self.convert(str)

    str.split(SEPARATOR).collect{|x| x.strip}.select{|x| x.length > 0}.uniq

  end

end