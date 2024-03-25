# Cerise::Gettext

GetText support for [Hanami applications](https://github.com/hanami/hanami)

## Installation

Add this line to your application's Gemfile:

```rb
group :cli, :development, :production, :test do
  gem "cerise-gettext"
end
```

(Make sure to include `:cli` group)

## Usage

`$ hanami install` will add

- `locales` to app/settings.rb - array of locale tags
- `LOCALES=TAG1,TAG2...` to .env.development.local and .env.test.local - source of the seting above

This gem defines following Rake tasks provided by GetText. Some of the defined tasks are

- gettext - Update *.mo
- gettext:po:update - Update *.po

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
