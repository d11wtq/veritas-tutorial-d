# A Tutorial D Parser for Veritas

Tutorial D is an example D language created by Hugh Darwen and Christopher Date,
for the querying of relational data, remaining faithful to the true relational
algebra, in contrast to SQL.  It is a powerful query language, exceeding SQL in
many respects, yet no industrial implementations exist to date, since the
language serves mostly as an example language and was not specified for production
use.  Darwen and Date's specification says as much, but also says that with some
enhancements, such as formalized error reporting and any implementation-specific
features, Tutorial D could very well serve as an industrial strength query language.

This project aims mostly to explore what querying structured data with Tutorial D
feels like in practice, and to test Veritas' capabilities.

See:

  - http://www.dcs.warwick.ac.uk/~hugh/CHAP05.pdf
  - http://www.bookdepository.co.uk/Database-Depth-CJ-Date/9780596100124

## Work in Progress

This project has only just been born.  You should not expect, well, anything at all
to work in the current state, but work is underway to build up the interpreter.

## Example Usage

Unless you want to use the interpreter as a glorified infix calculator, the current
progress means all you can really do is create `Veritas::Relation` objects of the
form:

``` ruby
require "veritas-tutorial-d"

td = Veritas::TD::Interpreter.new
rel = td.eval <<-QUERY
  RELATION { TUPLE { UNO 20, UNAME 'Bob', ADMIN TRUE },
             TUPLE { UNO 21, UNAME 'Sam', ADMIN FALSE } }
QUERY

rel.each { |tuple| p tuple[:UNO] }
```

Check back regularly for updates as more of the grammar is implemented.

## Development Strategy

Tutorial D is a complete language with scalars, custom types, variables and fundamental
constructs, such as tuples, headers and relations.  Without these fundamental building
blocks, nothing useful can be done, so the current focus is on getting a functionally
complete relation literal working.  That is, to be able to return a `Veritas::Relation`
given a query that starts `RELATION { ... }`, but not with any operation support. This
involves the ability to parse the following formats:

TABLE_DUM (also `TABLE_DUM`) (done):

```
RELATION { }
```

TABLE_DEE (also `TABLE_DEE`) (done):

```
RELATION { TUPLE {} }
```

With tuple literals (done for a single attribute and single tuple):

```
RELATION { TUPLE { NAME1 value1, NAME2 value2 },
           TUPLE { NAME1 value1, NAME2 value2 } }
```

With a header specified (todo):

```
RELATION { UNO INTEGER, UNAME CHAR }
         { TUPLE { UNO 1, UNAME 'Bob' },
           TUPLE { UNO 2, UNAME 'Sam' } }
```

With attribute selectors for custom types (not sure how Veritas handles this):

```
RELATION { UNO UNO, UNAME CHAR }
         { TUPLE { UNO UNO(1), UNAME 'Bob' },
           TUPLE { UNO UNO(2), UNAME 'Sam' } }
```

With expressions representing attribute values (todo, though it may work, I haven't tested):

```
RELATION { UNO UNO, UNAME CHAR }
         { TUPLE { UNO UNO(2 * 2), UNAME 'Bob' },
           TUPLE { UNO UNO(3 * 2), UNAME 'Sam' } }
```

## TODO

  - Rename `#eval` to `#execute`?

## Known Issues

This represents a single day's work (if you count the fact I deleted everything and started over),
there some major issues I need to address, most notably some inputs cause 'Stack Level Too Deep'
instead of causing a parse error.  This should be easy to fix with some rule re-adjustment to
cut out whereever the recursion is occuring.
