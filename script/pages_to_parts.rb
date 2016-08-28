#for i in 34..51 do
  book = Refinery::Books::Book.find(67)
  book.contents_elements.each do |ce|
    if ce.ce_type == Refinery::Books::ContentsElement::PAGE_CE_TYPE
      ce.ce_type = Refinery::Books::ContentsElement::PART_CE_TYPE
      ce.save!
    end
  end
#end