Better project structures in R [![Build Status](https://travis-ci.org/robertzk/Ramd.svg?branch=master)](https://travis-ci.org/robertzk/Ramd) [![Coverage Status](https://coveralls.io/repos/robertzk/Ramd/badge.png)](https://coveralls.io/r/robertzk/Ramd)
-------------------

Like [require.js](http://requirejs.org/) was necessary to introduce structure and
modularity into Javascript, Ramd aims to do the same for R.

Most R projects are a collection of loosely organized scripts that include
each other through haphazard `source` calls. However, this often pollutes
the global namespace and makes it easy for the developer to be stranded in
a limbo in which they are unsure of the present state of the program.
The result is unnecessary time wasted in restarting and re-executing
past work.

Ramd aims to solve this problem by explicitly declaring dependencies. Consider
the example below.

Usage
--------

Consider the following files.

```r
### main.r
define('blah/foo', 'blah2/faa', function(one, two) {
  print(one + two)
})

### blah/foo.r
x <- 1
y <- 2
x + y

### blah2/faa.r
z <- 1
w <- 5
w - z

### R console
library(Ramd); source('main.r')
# > [1] 7
```

By separating out (this trivial example) into several pieces, it makes it
easier to re-use that logic elsewhere, and prevents us from having to
make global variables to communicate between files: when using Ramd's `define`
function to include files (relative to the fine that is performing the `define`)
the last value in that value is the "return value" (in the same way that [node.js](http://nodejs.org/)
files have an "exports").

In general, we can use `define` to include other scripts. Anything in those scripts
will not pollute the global namespace, and the last expression in the script will
be the "return value". If you need several things from a file, just wrap them in a
list!

```r
define('../some_file', 'another/file', function(first, second) {
  # The object "first" will be the result of executing some_file.R in
  # the parent directory.

  # The object "second" will be the result of executing another/file.R
  # relative to this file's directory.

  # Anything computed in this block will not affect the global namespace,
  # and can safely by assigned (e.g., "x <- define(...)") or returned
  # to another (recursive) define call (if this file itself is
  # being included with "define").
})
```

In general, using `define` will bypass the global environment, as it is meant to
encourage modular code without [side effects](http://en.wikipedia.org/wiki/Side_effect_%28computer_science%29).
