# danger-asana

A [Danger](https://github.com/danger/danger) plugin for that links Asana issues to pull requests for both GitHub and GitLab.

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

Generate a [Personal Access Token](https://developers.asana.com/docs/personal-access-token) on Asana and add it as en environment variable `_ASANA_TOKEN`

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
