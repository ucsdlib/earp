# Hi Five!
An application supporting an Employee Recognition program workflow

[![Coverage Status](https://coveralls.io/repos/github/ucsdlib/hifive/badge.svg)](https://coveralls.io/github/ucsdlib/hifive)

[![CircleCI](https://circleci.com/gh/ucsdlib/hifive/tree/master.svg?style=svg)](https://circleci.com/gh/ucsdlib/hifive/tree/master)


## Local Development
### Secrets
This app is using Rails 5.2+ encrypted secrets, stored in
`config/credentials.yml.enc`. In order to access them, you'll need to set the
master key in `config/master.key`, stored in LastPass currently (final location
TBD)

To edit secrets: `bin/rails credentials:edit`

### Docker
1. Install docker and docker-compose
1. Run docker-compose file `docker-compose up`

**note** at the moment, the Chromium/Chromedriver versions on Alpine linux will
not work with Capybara. So for now, run the application locally, and the
docker-compose file will just run the database in a container.
1. In a separate tab, setup the db `bin/rails db:create db:migrate`

OR (if you would like to pre-load Employee table for local dev)
1. In a separate tab, setup the db `bin/rails db:setup`

**when Alpine available again**
1. In a separate tab, setup the db `docker-compose exec web bin/rails db:create db:migrate`
OR (if you would like to pre-load Employee table for local dev)
1. In a separate tab, setup the db `docker-compose exec web bin/rails db:setup`

#### Debugging
With docker-compose running, in a new terminal/tab attach to the container:
`docker attach hifive_web_1`
