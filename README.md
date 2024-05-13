# PrettyLogger

Quick and simple Rails logger that lets you output to a different log file for more controlled breakdowns of site visits.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add pretty_logger

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install pretty_logger

## Usage

Add `before_action :pretty_logit` to your ApplicationController. Now you have pretty logs getting output to `log/custom_log.log`



## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

- [ ] Add a config that can be set in an initializer for accessing user and prettifying in logs
- [ ] Customize location of custom_log file
- [ ] Don't auto-hijack errors, should need to add that manually?

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PrettyLogger project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pretty_logger/blob/master/CODE_OF_CONDUCT.md).
