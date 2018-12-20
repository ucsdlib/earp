# Hi Five!
An application supporting an Employee Recognition program workflow

[![Coverage Status](https://coveralls.io/repos/github/ucsdlib/hifive/badge.svg)](https://coveralls.io/github/ucsdlib/hifive)

[![CircleCI](https://circleci.com/gh/ucsdlib/hifive/tree/master.svg?style=svg)](https://circleci.com/gh/ucsdlib/hifive/tree/master)


## Local Development
### Email / Letter Opener
To view emails submitted in a development context, you can navigate to:
```
http://localhost:3000/letter_opener
```
### Secrets
This app is using Rails 5.2+ encrypted secrets, stored in
`config/credentials.yml.enc`. In order to access them, you'll need to set the
master key in `config/master.key`, stored in LastPass currently (final location
TBD)

To edit secrets: `bin/rails credentials:edit`

### Docker
1. Install docker and docker-compose
1. Run docker-compose file `docker-compose up`

#### Employee Data
To load employee data locally, after running the docker commands above to start
up the local environment, you can run the `db:seed` rake command as follows:

`docker-compose exec web rake db:seed`

Note that you will need to either be on campus or using the VPN, as this
accesses LDAP data from Active Directory.

#### Testing
1. Run tests with `docker-compose exec web` prefix for any RSpec command.

Examples:
```
docker-compose exec web bin/rails spec
docker-compose exec web bundle exec rake spec
docker-compose exec web bundle exec rake spec/models/user.rb
docker-compose exec web bundle exec rake spec/models/user.rb:50
...
```

#### Debugging
With docker-compose running, in a new terminal/tab attach to the container:
`docker attach hifive_web_1`
