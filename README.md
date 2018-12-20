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
1. To spin up your environment, run `./bin/docker-helper.sh`
    - Run `./bin/docker-helper.sh -h` to see all options

#### Employee Data
To load employee data locally, after running the docker commands above to start
up the local environment, you can run the `db:seed` rake command as follows:

You can use the helper script:

Development:

`./bin/docker-helper.sh -s`

Production:

`./bin/docker-helper.sh -p -s`

Or you can invoke directly (development example):

`docker-compose -f docker/development/docker-compose.yml exec web rake db:seed`

Note that you will need to either be on campus or using the VPN, as this
accesses LDAP data from Active Directory.

#### Testing
1. For full test suite, run `./bin/docker-helper.sh -t`
1. Run individual tests with `docker-compose -f docker/development/docker-compose.yml exec web` prefix for any RSpec command.

Examples:
```
docker-compose -f docker/development/docker-compose.yml exec web bin/rails spec
docker-compose -f docker/development/docker-compose.yml exec web bundle exec rake spec
docker-compose -f docker/development/docker-compose.yml exec web bundle exec rake spec/models/user.rb
docker-compose -f docker/development/docker-compose.yml exec web bundle exec rake spec/models/user.rb:50
...
```

#### Troubleshooting
If you get odd errors about tmp or cached file permissions, particularly if you
are testing both the development and production docker environments, you should
try removing the cached files in the `./tmp` folder.

`sudo rm -rf ./tmp/cache`

#### Debugging
With docker-compose running, in a new terminal/tab attach to the container:
`docker attach hifive_web_1`

### Production Docker
The main `Dockerfile` is setup for production. If you want to run this locally,
you can use the `./bin/docker-helper.sh -p` script.

Note you _cannot_ run the test suite in this environment. The tooling is not in place.
