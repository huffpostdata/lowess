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

# returns (1.0000, 1.1457) (1.3000, 1.1576) (1.7000, 1.1455) (2.1000, 1.0849)
Lowess::lowess(points, f: 1.0, iter: 4).join(' ')
```

# Development

*To run tests*: `rake`

*To fiddle with C*: look in `ext/ext_lowess`

*To build the gem*: `rake gem`

# License

[GPL2](http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html) because the
code is downloaded from R automatically.
