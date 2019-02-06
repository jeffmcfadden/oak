# Oak
A rails blogging engine (Rails 5.2+) that supports modern IndieWeb standards, like MicroPub and IndieAuth.


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'oak-rails', github: 'jeffmcfadden/oak'
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

## Configuration

Create a file in your rails app `config/initializers/oak.rb`

Here's an example configuration:

```ruby
Oak.configure do |config|
  config.author_class = "User"
  
  if Rails.env.development?
    config.site_name = "TEST My Great Blog"
  else
    config.site_name = "My Great Blog"
  end
  
  config.site_description = "The words of a writer, written down."
  
  config.posts_per_page = 8
  
  config.tags_to_exclude_from_home_page = ['micro','secret']
  
end
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
* Support for Media uploads via Admin
* Receiving Webmentions (just displayed in admin at this time)
* Sending Webmentions (sent manually at this time)
* Micropub Media Endpoint

## Still Working On

* Deleting / Undeleting Posts
* Easier/Better Integration with the host application. Still requires a lot of hand-work to get things working smoothly.
* Syndication
* Pubsub

## Micropub Spec Implementation Status

Currently **21/34** test passing at the micropub.rocks tests: [https://micropub.rocks/implementation-reports/servers/278/Ix5NV57E72H4mWjUhdIh](https://micropub.rocks/implementation-reports/servers/278/Ix5NV57E72H4mWjUhdIh)

Or, checkout the entire [W3C Micropub Spec](https://www.w3.org/TR/micropub/#feature-li-1).

## Contributing
Fork, pull request.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
