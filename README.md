# KonturFocus

Обертка над Контур.Фокус API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kontur-focus'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kontur-focus

## Usage

```ruby
KonturFocus.configure do |config|
  config.key = <key>
  config.version = <version>
end

KonturFocus.api.req('<ИНН>')
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/unact/kontur-focus.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
