# KawaiiEmailAddress

Extraction of validate logic from `validates_email_format_of` to support japanese docomo/au addresses.

## Installation

Add this line to your application's Gemfile:

    gem 'kawaii_email_address'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kawaii_email_address

## Usage

It's NOT Rails' validator. Use it with this

```
KawaiiEmailAddress::Validator.new(email_address_string).valid?

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## THANX

This library based on https://github.com/alexdunae/validates_email_format_of
