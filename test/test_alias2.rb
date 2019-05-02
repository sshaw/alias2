require "minitest/autorun"
require "alias2"

module Other
  module Namespace
  end
end

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

  def test_with_target_in_existing_namespace
    alias2 "A::B", "Bar" => "Other::Namespace::Bar"

    assert Object.const_defined?("A::B::Bar")
    assert Object.const_defined?("Other::Namespace::Bar")

    assert_equal A::B::Bar, Other::Namespace::Bar
  end

  def test_with_target_in_toplevel_namespace
    alias2 "A::B", "Bar" => "::Bar"

    assert Object.const_defined?("A::B::Bar")
    assert Object.const_defined?("Bar")

    assert_equal A::B::Bar, Bar
  end

  def test_with_target_in_new_namespace
    alias2 "A::B", "Bar" => "My::New::Namespace::Bar"

    assert Object.const_defined?("A::B::Bar")
    assert Object.const_defined?("My::New::Namespace::Bar")

    assert_equal A::B::Bar, My::New::Namespace::Bar
  end

  def test_error_raised_when_constant_already_defined
    ex = assert_raises NameError do
      alias2 "A::B", "Bar" => "A::Baz"
    end

    assert_equal "constant A::Baz is already defined", ex.message
  end

  def test_with_target_of_astrisk
    alias2 A::B, "*"

    assert Object.const_defined?("Bar")
    assert Object.const_defined?("Foo")
    assert !Object.const_defined?("X")
  end

  def test_with_filter_only_filtered_modules_aliased
    alias2 A::B do |klass|
      klass == A::B::Foo
    end

    assert Object.const_defined?("A::B::Foo")
    assert Object.const_defined?("Foo")
    assert_equal A::B::Foo, Foo

    assert !Object.const_defined?("Bar")
    assert !Object.const_defined?("X")
  end

  def test_with_filter_only_modules_filtered
    seen = []
    alias2 A::B do |klass|
      seen << klass
      true
    end

    # A::B::X is an Integer constant
    assert_equal [A::B::Bar, A::B::Foo], seen
  end

  def test_with_filter_and_aliases_only_filtered_modules_aliased
    alias2 A::B, "Foo" => "X1", "Bar" => "X2" do |klass|
      klass == A::B::Foo
    end

    assert Object.const_defined?("A::B::Foo")
    assert Object.const_defined?("X1")
    assert_equal A::B::Foo, X1

    assert Object.const_defined?("A::B::Bar")
    assert !Object.const_defined?("X2")
  end

  def test_with_filter_with_alias_returned_uses_alias
    alias2 A::B, "Foo" => "X1", "Bar" => "X2" do |klass|
      klass == A::B::Foo ? "X_1" : "X_2"
    end

    assert Object.const_defined?("A::B::Foo")
    assert Object.const_defined?("X_1")
    assert_equal A::B::Foo, X_1

    assert Object.const_defined?("A::B::Bar")
    assert Object.const_defined?("X_2")
    assert_equal A::B::Bar, X_2
  end
end
