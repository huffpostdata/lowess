require 'minitest/autorun'
require 'lowess'

class LowessTest < Minitest::Test
  def test_typical_input
    # R session:
    #
    # > x <- c(0, 1, 2, 3, 4)
    # > y <- c(2, 3, 1, 5, 4)
    # > lowess(x=x, y=y, f=1)
    # $x
    # [1] 0 1 2 3 4
    #
    # $y
    # [1] 2.102895 2.549205 3.183370 3.727202 4.376544
    #
    out = Lowess::lowess([ p(0, 2), p(1, 3), p(2, 1), p(3, 5), p(4, 4) ], f: 1)
    assert_near [ p(0, 2.102895), p(1, 2.549205), p(2, 3.183370), p(3, 3.727202), p(4, 4.376544) ], out
  end

  def test_zero_inputs
    # R session:
    #
    # > x <- c()
    # > y <- c()
    # > lowess(x=x, y=y)
    # Error in lowess(x, y) : invalid input
    assert_raises ::ArgumentError do
      Lowess::lowess([])
    end
  end

  def test_one_input
    # R session:
    #
    # > x <- c(0)
    # > y <- c(1)
    # > lowess(x=x, y=y)
    # $x
    # [1] 0
    #
    # $y
    # [1] 1
    out = Lowess::lowess([ p(0, 1) ])
    assert_equal [ p(0, 1) ], out
  end

  def test_two_inputs
    # R session:
    #
    # > x <- c(0, 1)
    # > y <- c(0.2, 0.2)
    # > lowess(x, y)
    # $x
    # [1] 0 1
    #
    # $y
    # [1] 0.2 0.2
    input = [ p(0, 0.2), p(1, 0.2) ]
    assert_equal input, Lowess::lowess(input)
  end

  def test_f
    # R session:
    #
    # > x <- c(0, 1, 2, 3, 4)
    # > y <- c(2, 3, 1, 5, 4)
    # > lowess(x, y, f=0.8)
    # $x
    # [1] 0 1 2 3 4
    #
    # $y
    # [1] 2.314658 2.180697 2.847178 3.562879 4.498597
    assert_near ps(%w(2.314658 2.180697 2.847178 3.562879 4.498597)), Lowess::lowess(ps([ 2, 3, 1, 5, 4 ]), f: 0.8)
  end

  def test_iter
    # R session:
    #
    # > x <- c(0, 1, 2, 3, 4)
    # > y <- c(2, 3, 1, 5, 4)
    # > lowess(x, y, f=0.8, iter=1)
    # $x
    # [1] 0 1 2 3 4
    #
    # $y
    # [1] 2.322932 2.167876 2.809222 3.553910 4.517957
    assert_near ps(%w(2.322932 2.167876 2.809222 3.553910 4.517957)), Lowess::lowess(ps([ 2, 3, 1, 5, 4 ]), f: 0.8, iter: 1)
  end

  def test_delta
    # R session:
    #
    # > x <- c(0, 1, 2, 3, 4)
    # > y <- c(2, 3, 1, 5, 4)
    # > lowess(x, y, f=0.9, delta=2.0)
    # $x
    # [1] 0 1 2 3 4
    #
    # $y
    # [1] 2 3 4 4 4
    assert_near ps(%w(2 3 4 4 4)), Lowess::lowess(ps([ 2, 3, 1, 5, 4 ]), f: 0.8, delta: 2.0)
  end

  def test_non_uniform_line
    # R session:
    #
    # > x <- c(1, 1.1, 2, 2, 3)
    # > y <- c(1.1, 1.2, 2.2, 1.2, 3.1)
    # > lowess(x, y)
    # $x
    # [1] 1.0 1.1 2.0 2.0 3.0
    #
    # $y
    # [1] 1.1 1.2 1.7 1.7 3.1
    input = [ p(1, 1.1), p(1.1, 1.2), p(2, 2.2), p(2, 1.2), p(3, 3.1) ]
    expect_output = [ p(1, 1.1), p(1.1, 1.2), p(2, 1.7), p(2, 1.7), p(3, 3.1) ]
    assert_near expect_output, Lowess::lowess(input)
  end

  def test_example_from_readme
    points = [
      Lowess::Point.new(1, 1.1),
      Lowess::Point.new(1.3, 1.3),
      Lowess::Point.new(1.7, 1.1),
      Lowess::Point.new(2.1, 1.1)
    ]

    expect = '(1.0000, 1.1457) (1.3000, 1.1576) (1.7000, 1.1455) (2.1000, 1.0849)'

    assert_equal expect, Lowess::lowess(points, f: 1.0, iter: 4).join(' ')
  end

  private

  def assert_near(pts1, pts2)
    xs1 = pts1.map { |pt| pt.x.round(4) }
    xs2 = pts2.map { |pt| pt.x.round(4) }
    ys1 = pts1.map { |pt| pt.y.round(4) }
    ys2 = pts2.map { |pt| pt.y.round(4) }

    rounded1 = xs1.zip(ys1).map { |x, y| Lowess::Point.new(x, y) }
    rounded2 = xs2.zip(ys2).map { |x, y| Lowess::Point.new(x, y) }

    assert_equal rounded1, rounded2
  end

  def ps(ys)
    ys.each_with_index.map { |y, i| Lowess::Point.new(i, y) }
  end

  def p(x, y)
    Lowess::Point.new(x, y)
  end
end
