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

* Updating Posts
* Deleting Posts
* Undeleting Posts
* Easier/Better Integration with the host application. Still requires a lot of hand-work to get things working smoothly.
* Syndication
* Pubsub

## Micropub Spec Implementation Status

Currently **21/34** test passing at the micropub.rocks tests: [https://micropub.rocks/implementation-reports/servers/278/Ix5NV57E72H4mWjUhdIh](https://micropub.rocks/implementation-reports/servers/278/Ix5NV57E72H4mWjUhdIh)

The following features constitute the [W3C Micropub Spec](https://www.w3.org/TR/micropub/#feature-li-1).

* :white_check_mark: Discovering the Micropub endpoint given the profile URL of a user
* :white_check_mark: Authenticating requests by including the access token in the HTTP `Authorization` header
* :white_check_mark: Authenticating requests by including the access token in the post body for `x-www-form-urlencoded` requests
* :x: Limiting the ability to create posts given an access token by requiring that the access token contain at least one OAuth 2.0 scope value
* :white_check_mark: Creating a post using `x-www-form-urlencoded` syntax with one or more properties
* :white_check_mark: Creating a post using JSON syntax with one or more properties
* :white_check_mark: Creating a post using `x-www-form-urlencoded` syntax with multiple values of the same property name
* :white_check_mark: Creating a post using JSON syntax with multiple values of the same property name
* :x: Creating a post using JSON syntax including a nested Microformats2 object
* :white_check_mark: Uploading a file to the specified Media Endpoint
* :white_check_mark: Creating a post with a file by sending the request as `multipart/form-data` to the Micropub endpoint
* :white_check_mark: Creating a post with a photo referenced by URL
* :white_check_mark: Creating a post with a photo referenced by URL that includes image alt text
* :white_check_mark: Creating a post where the request contains properties the server does not recognize
* :white_check_mark: Returning `HTTP 201 Created` and a `Location` header when creating a post
* :x: Returning `HTTP 202 Created` and a `Location` header when creating a post
* :white_check_mark: Updating a post and replacing all values of a property
* :white_check_mark: Updating a post and adding a value to a property
* :white_check_mark: Updating a post and removing a value from a property
* :white_check_mark: Updating a post and removing a property
* :white_check_mark: Returning `HTTP 200 OK` when updating a post
* :x: Returning `HTTP 201 Created` when updating a post if the update cause the post URL to change
* :x: Returning `HTTP 204 No Content` when updating a post
* :x: Deleting a post using `x-www-form-urlencoded` syntax
* :x: Deleting a post using JSON syntax
* :x: Undeleting a post using `x-www-form-urlencoded` syntax
* :x: Undeleting a post using JSON syntax
* :white_check_mark: Uploading a photo to the Media Endpoint and using the resulting URL when creating a post
* :white_check_mark: Querying the Micropub endpoint with `q=config` to retrieve the Media Endpoint and syndication targets if specified
* :x: Querying the Micropub endpoint with `q=syndicate-to` to retrieve the list of syndication targets
* :x: Querying the Micropub endpoint for a post's source content without specifying a list of properties
* :x: Querying the Micropub endpoint for a post's source content looking only for specific properties


## Contributing
Fork, pull request.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
