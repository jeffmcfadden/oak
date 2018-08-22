# Oak
A rails blogging engine (Rails 5.2+) that supports modern IndieWeb standards, like MicroPub and IndieAuth.


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

Install and run the migrations

    $ rails oak:install:migrations
    $ rails db:migrate

* Install the Acts as Taggable migrations

Install Friendly ID if you didn't already have it in your app

```bash
$ rails generate friendly_id
$ rails db:migrate
```

## Limitations

* Intended only for a personal site with a single blog.
* Not intended for use with multiple authors, though you can _sorta_ get around that.

## What Works

* Authorizing via IndieAuth
* Publishing text via MicroPub
* Creating/Editing/Removing Posts
* RSS Feed
* JSON Feed
* Tags

## Still Working On

* Easier/Better Integration with the host application. Still requires a lot of hand-work to get things working smoothly.
* Syndication
* Webmentions
* Pubsub
* Support for Media uploads

## Contributing
Fork, pull request.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
