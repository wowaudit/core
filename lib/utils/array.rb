class Array
  def median
    (sort[(sort.length - 1) / 2] + sort[sort.length / 2]) / 2.0
  end

  def mean
    sum / size
  end
end
