# 🌲 Timber - Great Ruby Logging Made Easy

[![ISC License](https://img.shields.io/badge/license-ISC-ff69b4.svg)](LICENSE.md)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://www.rubydoc.info/github/timberio/timber-ruby-rack)
[![Build Status](https://travis-ci.org/timberio/timber-ruby-rack.svg?branch=master)](https://travis-ci.org/timberio/timber-ruby-rack)
[![Code Climate](https://codeclimate.com/github/timberio/timber-ruby-rack/badges/gpa.svg)](https://codeclimate.com/github/timberio/timber-ruby-rack)

Timber for Ruby is a drop in replacement for your Ruby logger that
[unobtrusively augments](https://timber.io/docs/concepts/structuring-through-augmentation) your
logs with [rich metadata and context](https://timber.io/docs/concepts/metadata-context-and-events)
making them [easier to search, use, and read](#get-things-done-with-your-logs). It pairs with the
[Timber console](#the-timber-console) to deliver a tailored Ruby logging experience designed to make
you more productive.

1. [**Installation**](#installation)
2. [**Usage** - Simple & powerful API](#usage)
3. [**Configuration**](#configuration)


## Installation

1. In your `Gemfile`, add the `timber-rails` gem:

    ```ruby
    gem 'timber-rack', '~> 1.0'
    ```

2. TODO

   ```ruby
   use Timber::Integrations::Rack::HTTPContext
   use Timber::Integrations::Rack::UserContext
   use Timber::Integrations::Rack::HTTPEvents
   use Timber::Integrations::Rack::ErrorEvent
   ```

## Usage

Use the `Timber::Logger` just like you would `::Logger`:

```ruby
logger.debug("Debug message")
logger.info("Info message")
logger.warn("Warn message")
logger.error("Error message")
logger.fatal("Fatal message")
```

## Configuration

Below are a few popular configuration options, for a comprehensive list, see
[Timber::Config](http://www.rubydoc.info/github/timberio/timber-rack/Timber/Config).

### Reduce Logging

```ruby
Timber.config.integrations.rack.http_events.collapse_into_single_event = true
```

It turns this:

```
Started GET "/"
Completed 200 OK in 1.2ms
```

Into this:

```
GET / completed with 200 OK in 1.2ms
```

### Silence Specific Requests


Silencing noisy requests can be helpful for silencing load balance health checks, bot scanning,
or activity that generally is not meaningful to you. The following will silence all
`[GET] /_health` requests:

```ruby
Timber.config.integrations.rack.http_events.silence_request = lambda do |rack_env, rack_request|
  rack_request.path == "/_health"
end
```

We require a block because it gives you complete control over how you want to silence requests.
The first parameter being the traditional Rack env hash, the second being a
[Rack Request](http://www.rubydoc.info/gems/rack/Rack/Request) object.

### User Context

By default Timber automatically captures user context for most of the popular authentication
libraries (Devise, and Clearance). See
[Timber::Integrations::Rack::UserContext](http://www.rubydoc.info/github/timberio/timber-rack/Timber/Integrations/Rack/UserContext)
for a complete list.

In cases where you Timber doesn't support your strategy, or you want to customize it further,
you can do so like:

```ruby
Timber.config.integrations.rack.user_context.custom_user_hash = lambda do |rack_env|
  user = rack_env['warden'].user
  if user
    {
      id: user.id, # unique identifier for the user, can be an integer or string,
      name: user.name, # identifiable name for the user,
      email: user.email, # user's email address
    }
  else
    nil
  end
end
```

*All* of the user hash keys are optional, but you must provide at least one.
