# singleton

Singleton library for Crystal. Created out of necessity to work around the problem with class variables inside of generic classes.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  singleton:
    github: waterlink/singleton.cr
```

## Usage

```crystal
require "singleton"
```

### Fetching instance of certain type

```crystal
Singleton::Of(Example).instance
```

This uses `Example.new` to produce the instance.

Making singleton out of `Example(T)` class now would look like that:

```crystal
class Example(T)
  def self.instance
    Singleton::Of(self).instance
  end
end
```

### Resetting all singletons (in tests)

```crystal
Singleton.reset
```

## Contributing

1. Fork it ( https://github.com/waterlink/singleton.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [waterlink](https://github.com/waterlink) Oleksii Fedorov - creator, maintainer
