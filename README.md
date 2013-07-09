# EmailFormatValidator

Extraction of validate logic from `validates_email_format_of` to support japanese docomo/au addresses.

## Installation

Add this line to your application's Gemfile:

    gem 'email_format_validator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install email_format_validator

## Usage

It's NOT Rails' validator. Use it with this

```
EmailFormatValidator::Adress.new(email_address_string).valid?

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## THANX

This library based on https://github.com/alexdunae/validates_email_format_of
