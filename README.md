# earp
An application supporting an Employee Recognition program workflow

[![Coverage Status](https://coveralls.io/repos/github/ucsdlib/earp/badge.svg?branch=master)](https://coveralls.io/github/ucsdlib/earp?branch=master)

[![CircleCI](https://circleci.com/gh/ucsdlib/earp/tree/master.svg?style=svg)](https://circleci.com/gh/ucsdlib/earp/tree/master)

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
1. In a separate tab, setup the db `docker-compose exec web bin/rails db:create db:migrate`

#### Debugging
With docker-compose running, in a new terminal/tab attach to the container:
`docker attach earp_web_1`
