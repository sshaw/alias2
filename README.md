# alias2

Make classes, modules, and constants accessible via a different namespace.

[![Build Status](https://travis-ci.org/sshaw/alias2.svg?branch=master)](https://travis-ci.org/sshaw/alias2)

## Usage

```rb
require "alias2"
require "some/very/long/name/here" # If not already loaded (or autoloaded)
```

An `Array` of constant names to alias can be provided:
```rb
alias2 Some::Very::Long::Name::Here, %w[Foo Bar Baz]
```

This is the same as:
```rb
Foo = Some::Very::Long::Name::Here::Foo
Bar = Some::Very::Long::Name::Here::Bar
Baz = Some::Very::Long::Name::Here::Baz
```

The namespace can also be a `String`.

To alias everything in the namespace to the top-level:
```rb
alias2 Some::Very::Long::Name::Here, "*"
```

Same as above:
```rb
Foo = Some::Very::Long::Name::Here::Foo
Bar = Some::Very::Long::Name::Here::Bar
Baz = Some::Very::Long::Name::Here::Baz
```

If you'd like to alias them using a different name you can:
```rb
alias2 Some::Very::Long::Name::Here, :Foo => "FooHoo", :Bar => "BarHar", :Baz => "Bazzzz"
```

Same as:
```rb
FooHoo = Some::Very::Long::Name::Here::Foo
BarHar = Some::Very::Long::Name::Here::Bar
Bazzzz = Some::Very::Long::Name::Here::Baz
```

Keys can also be `String`s.

You can filter the classes/modules to alias:
```rb
alias2 Some::Very::Long::Name::Here, "*" do |klass|
  klass < ActiveRecord::Base
end
```

The above is the same as:
```rb
Foo = Some::Very::Long::Name::Here::Foo if Some::Very::Long::Name::Here::Foo.is_a?(ActiveRecord::Base)
Bar = Some::Very::Long::Name::Here::Bar if Some::Very::Long::Name::Here::Bar.is_a?(ActiveRecord::Base)
Baz = Some::Very::Long::Name::Here::Baz if Some::Very::Long::Name::Here::Baz.is_a?(ActiveRecord::Base)
```

When a block is given you can omit the alias. It will default to `"*"`.

The block can also return an alias:
```rb
alias2 Some::Very::Long::Name::Here do |klass|
  klass.name.end_with?("Foo") ? "Foo_X" : klass.name.split("::")[-1]
end
```

This is the same as:
```rb
Foo_X = Some::Very::Long::Name::Here::Foo if Some::Very::Long::Name::Here::Foo.name.end_with?("Foo")
Bar = Some::Very::Long::Name::Here::Bar
Baz = Some::Very::Long::Name::Here::Baz
```

An alias' target can also be a namespace you want created:
```rb
alias2 Some::Very::Long::Name::Here, :Foo => "New::Namespace::SameFoo", :Bar => "BarHar"
```

Same as:
```rb
module New
  module Namespace
    SameFoo = Some::Very::Long::Name::Here::Foo
  end
end

BarHar = Some::Very::Long::Name::Here::Bar
```

Or it can be an existing namespace:
```rb
alias2 Some::Very::Long::Name::Here, :Foo => "Existing::Namespace::Foo", :Bar => "BarHar"
```

Same as:
```rb
Existing::Namespace::Foo = Some::Very::Long::Name::Here::Foo
BarHar = Some::Very::Long::Name::Here::Bar
```

In all cases the original namespace is not modified and remains in scope.

### Errors

- `NameError` - raised when a constant cannot be found or when a constant is already defined
- `ArgumentError` - raised when an alias list or block is not provided

## See Also

* [aliased](https://metacpan.org/pod/aliased) - The Perl module that served as inspiration
* [require3](https://github.com/sshaw/require3) - `Kernel#require` something and make it accessible via a different namespace
* [class2](https://github.com/sshaw/class2) - Easily create hierarchies that support nested attributes, type conversion, serialization and more

## Author

Skye Shaw [skye.shaw AT gmail]

## License

Released under the MIT License: http://www.opensource.org/licenses/MIT
