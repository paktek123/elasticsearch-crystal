# Mock [![Build Status](https://travis-ci.org/porras/mock.svg?branch=master)](https://travis-ci.org/porras/mock)

Mock is a doubles (stubs and mocks) library for [Crystal](http://crystal-lang.org/), inspired by the API of [rspec-mocks](https://github.com/rspec/rspec-mocks) (but it implements a small basic subset of it to the date).

## Installation

Add this to your application's shard.yml:

```yaml
development_dependencies:
  mock:
    github: porras/mock
```

You can now run `shards` to install it.

## Usage

Require it in your tests and you can start using it.

```crystal
require "mock"
```

### Creating a double

Just call the `double()` method.

### Stubbing a method

Calling `stub` on that double object will set a method stub:

```crystal
my_object = double()
my_object.stub(:my_method)
```

You can establish a return value for the stub method (if you don't, method stubs return `nil`):

```crystal
my_object = double()
my_object.stub(:my_method).and_return("my value")

my_object.my_method.should eq("my value")
```

You can also filter my arguments, establishing different stubs for the same method:

```crystal
my_object = double()
my_object.stub(:my_method).with(1).and_return("value 1")
my_object.stub(:my_method).with(2).and_return("value 2")

my_object.my_method(1).should eq("value 1")
my_object.my_method(2).should eq("value 2")
```

### Setting expectations

You can also set the expectation that a method will be called, and it will be automatically checked at the end of the test:

```crystal
my_object = double()
my_object.should_receive(:my_method).with(1).and_return("my value")

# if we omit this line, the test will fail
my_object.my_method(1).should eq("value 1")
```

See [example_spec.cr](https://github.com/porras/mock/blob/master/spec/example_spec.cr) for more examples.

## Contributing

1. Fork it ( https://github.com/porras/mock/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## License

This code is released under the [MIT License](https://github.com/porras/mock/blob/master/LICENSE).

## Contributors

- [Sergio Gil](http://iamserg.io)
