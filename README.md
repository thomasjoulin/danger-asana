# danger-asana

A description of danger-asana.

## Installation

    $ gem install danger-asana

## Usage

In your Dangerfile:

```ruby
asana.check(
  search_title: true,
  search_commits: true,
  search_commits: true,
)
```

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
