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

for i in 152..181 do
  shift = 3

  shift = 4 if [150].include?(i)

  book = Refinery::Books::Book.find(i)
  book.contents_elements.each do |ce|
    ce.page_number -= shift
    ce.save!
  end

  min_page = book.book_pages.collect{|x| x.internal_order}.min

  book.book_pages.each do |page|
    page.internal_order -= shift

    if page.internal_order <= 0

      page.url_name = to_roman(page.internal_order - (min_page - shift - 1))

    else
      page.url_name = page.internal_order.to_s
    end

    page.save!

  end
end