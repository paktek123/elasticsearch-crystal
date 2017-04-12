# spec2-mocks

This is an adapter of [mocks.cr](https://github.com/waterlink/mocks.cr)
for [spec2.cr](https://github.com/waterlink/spec2.cr).

## Installation

Make sure, that you have correct versions of `spec2` and `mocks` in you
`shard.yml` in `depdendencies` section.

Next, add this to your application's `shard.yml`:

```yaml
dependencies:
  spec2-mocks:
    github: waterlink/spec2-mocks.cr
    version: ~> 0.4
```

## Usage

```crystal
require "spec2-mocks"
```

This additionally adds `before { Mocks.reset }` to each top-level
`Spec2.describe`.

### Using `have_received` matcher

```crystal
expect(person).to have_received(say("hello world"))
```

### Using `receive` matcher

```crystal
expect(person).to receive(say("hello world"))
```

This uses `spec2`'s `delayed { ... }` feature to verify expectations after the
end of the example.

## Development

After cloning the project:

```
cd spec2-mocks.cr
crystal deps   # install dependencies
crystal spec   # run specs
```

Just use normal TDD development style.

## Contributing

1. Fork it ( https://github.com/waterlink/spec2-mocks.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [waterlink](https://github.com/waterlink) Oleksii Fedorov - creator, maintainer
