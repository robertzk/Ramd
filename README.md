AMD (asynchronous module definitions) in R [![Build Status](https://travis-ci.org/robertzk/Ramd.svg?branch=master)](https://travis-ci.org/robertzk/Ramd)
=======

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

**TODO**.
