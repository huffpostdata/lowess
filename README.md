If you've ever used R's [lowess()](https://svn.r-project.org/R/tags/R-3-2-4/src/library/stats/src/lowess.doc)
and you wish you could call it from Ruby, this gem's for you.

# Installation

`gem install lowess`

or in your Gemfile:

`gem 'lowess'`

# Usage

```rb
require 'lowess'

points = [
  Lowess::Point.new(1, 1.1),
  Lowess::Point.new(1.3, 1.3),
  Lowess::Point.new(1.7, 1.1),
  Lowess::Point.new(2.1, 1.1)
]

# returns (1, 1.1531) (1.3, 1.1854) (1.7, 1.3444) (2.1, 1.6363)
Lowess::lowess(points, f: 1.0, iter: 4)
```

# Development

*To run tests*: `rake`

*To fiddle with C*: look in `ext/ext_lowess`

# License

[GPL2](http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html) because the
code is downloaded from R automatically.
