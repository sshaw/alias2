# alias2

Make classes, modules, and constants accessible via a different namespace.

[![Build Status](https://travis-ci.org/sshaw/alias2.svg?branch=master)](https://travis-ci.org/sshaw/alias2)

## Usage

```rb
require "alias2"
require "some/very/long/name/here"

alias2 Some::Very::Long::Name::Here, "*"
```

The namespace can also be a `String`:

```rb
alias2 "Some::Very::Long::Name::Here", "*"
```

`"*"` assigns every constant from `Some::Very::Long::Name::Here` to the top-level namespace. It's like doing this:
```rb
Foo = Some::Very::Long::Name::Here::Foo
Bar = Some::Very::Long::Name::Here::Bar
CONSTANT = Some::Very::Long::Name::Here::CONSTANT
# ...
# For all constants in Some::Very::Long::Name::Here
```


An `Array` of constants to alias can also be provided:
```rb
alias2 Some::Very::Long::Name::Here, %w[Foo Bar]
```

This is the same as:
```rb
Foo = Some::Very::Long::Name::Here::Foo
Bar = Some::Very::Long::Name::Here::Bar
```

If you'd like to alias them using a different name you can:
```rb
alias2 Some::Very::Long::Name::Here, "Foo" => "FooHoo", "Bar" => "BarHar"
```

Same as:
```rb
FooHoo = Some::Very::Long::Name::Here::Foo
BarHar = Some::Very::Long::Name::Here::Bar
```

## See Also

* [require2](https://github.com/sshaw/require2) - `Kernel#require` something and make it accessible via a different namespace
* [class2](https://github.com/sshaw/class2) - Easily create hierarchies that support nested attributes, type conversion, serialization and more

## Author

Skye Shaw [skye.shaw AT gmail]

## License

Released under the MIT License: http://www.opensource.org/licenses/MIT
