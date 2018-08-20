# Oak
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'oak'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install oak
```

Mount the engine in `routes.rb`:

    mount Oak::Engine, at: "/blog"


Install Friendly ID if you didn't already have it in your app

```bash
$ rails generate friendly_id
$ rails db:migrate
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
