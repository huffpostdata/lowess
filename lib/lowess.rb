# A LOWESS smoother
module Lowess
  # Smooths the input points
  #
  # Arguments:
  #
  # * points: Array of Lowess::Point objects, in any order.
  # * options: any of:
  #   * f: the smoother span. Larger values give more smoothness.
  #   * iter: the number of 'robustifying' iterations. Smaller is faster.
  #   * delta: minimum x distance between input points. Larger is faster.
  #
  # See https://stat.ethz.ch/R-manual/R-devel/library/stats/html/lowess.html
  # for more complete documentation.
  def self.lowess(points, options={})
    raise ArgumentError.new("Must pass one or more points") if points.empty?

    sorted_points = points.sort

    f = (options[:f] || 2.0 / 3).to_f
    iter = (options[:iter] || 3).to_i
    delta = (options[:delta] || (sorted_points.last.x - sorted_points.first.x).to_f / 100).to_f || 1.0

    ext_lowess(sorted_points, f, iter, delta)
  end
end

require 'lowess/point'
require 'ext_lowess'
