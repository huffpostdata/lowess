class Lowess::Point
  include Comparable

  attr_reader(:x, :y)

  def initialize(x, y)
    @x = x.to_f
    @y = y.to_f
  end

  def <=>(p2)
    if x != p2.x
      x <=> p2.x
    else
      y <=> p2.y
    end
  end

  def to_s
    sprintf("(%0.4f, %0.4f)", @x, @y)
  end
end
