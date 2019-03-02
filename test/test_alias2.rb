require "minitest/autorun"
require "alias2"

module A
  class Baz
  end

  module B
    X = 999

    class Bar
    end

    module Foo
    end
  end
end

class TestAlias2 < MiniTest::Test
  CONSTANTS = %w[Foo Bar Baz X]

  def teardown
    CONSTANTS.each do |name|
      Object.send(:remove_const, name) if Object.const_defined?(name)
    end
  end

  def test_with_simple_alias_with_string_namespace
    alias2 "A::B", "Foo"

    assert Object.const_defined?("Foo")
    assert Object.const_defined?("A::B")
    assert_equal A::B, Foo
  end

  def test_with_simple_alias_with_module_namespace
    alias2 A::B, "Foo"

    assert Object.const_defined?("Foo")
    assert Object.const_defined?("A::B")
    assert_equal A::B, Foo
  end

  def test_with_glob
    alias2 "A::B", "*"

    assert Object.const_defined?("Foo")
    assert Object.const_defined?("Bar")
    assert Object.const_defined?("X")
    assert Object.const_defined?("A::B::X")
    assert Object.const_defined?("A::B::Foo")
    assert Object.const_defined?("A::B::Bar")

    assert_equal A::B::X, X
    assert_equal A::B::Foo, Foo
    assert_equal A::B::Bar, Bar
  end

  def test_with_array_argument
    alias2 "A::B", %w[Foo Bar]

    assert Object.const_defined?("Foo")
    assert Object.const_defined?("Bar")
    assert Object.const_defined?("A::B::Foo")
    assert Object.const_defined?("A::B::Bar")

    assert_equal A::B::Foo, Foo
    assert_equal A::B::Bar, Bar
  end

  def test_with_hash_aliases
    alias2 "A", "B::Bar" => "Foo", "Baz" => "Baz"

    assert Object.const_defined?("Foo")
    assert Object.const_defined?("Baz")
    assert Object.const_defined?("A::B::Bar")
    assert Object.const_defined?("A::Baz")

    assert_equal A::B::Bar, Foo
    assert_equal A::Baz, Baz
  end
end
