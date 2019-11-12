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

### Environment Variables
This app is using ENV-driven configuration options through
[dotenv](https://github.com/bkeepers/dotenv) for non-production environments.

To override environment variables set by `.env`, create a `.env.local` file: <https://github.com/bkeepers/dotenv#what-other-env-files-can-i-use>.  We recommend adding the private variables into the `.env.local` file to avoid the risk of accidentally committing an updated file that contains the password.

For the docker-compose setup, there is also a `.env.docker` file. This is used
for environment variables that are required for the
`docker/docker-entrypoint.sh` script that `dotenv` will not have made available
yet. This allows the application to load the environment dotfile when needed
(for development or test) while keeping these variables separate.

### Docker
1. Install docker and docker-compose
1. To spin up your environment, run `make up`
    - Run `make menu` to see all options

> If you wish to persist your local development data across sessions, you can
temporarily change the `DATABASE_COMMAND` to something like `db:migrate`

#### Employee Data

> Note: To load the seed data, your local machine must have the `shuf` command
> Install on Mac OS by: brew install coreutils

To load employee data locally, after running the docker commands above to start
up the local environment, you can run the `db:seed` rake command as follows:

You can use the Makefile:

`make seed`

Or you can invoke directly (development example):

`docker-compose exec web rake db:seed`

Note that you will need to either be on campus or using the VPN, as this
accesses LDAP data from Active Directory. You will also need LDAP account info to load the seed data.  This info can be found in LastPass. You can put the following LDAP variables  `APPS_H5_LDAP_HOST, APPS_H5_LDAP_PORT, APPS_H5_LDAP_BASE, APPS_H5_LDAP_USERNAME, APPS_H5_LDAP_PW, APPS_H5_LDAP_GROUP` into `.env.local` file.

#### Testing
1. For full test suite, run `make test`
1. Run individual tests with `docker-compose exec web` prefix for any RSpec command.

Examples:
```
docker-compose exec web bin/rails spec
docker-compose exec web bundle exec rake spec
docker-compose exec web bundle exec rake spec/models/user.rb
docker-compose exec web bundle exec rake spec/models/user.rb:50
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

### Helm Chart Development
There is a Helm chart for the application in the ./hifive folder

#### Requirements
- Docker
- k3s
- k3d
- kubernetes
- helm

#### Local Values File
The `./k3d-hifive.sh` script will, by default, look for a file: `./hifive/local-values.yaml` which is expected to contain secrets and any variables that need to be overriddent in the Helm chart for a successful local deployment.

You can alternatively set your own file location using the
`HIGHFIVE_LOCAL_VALUES` environment variable.

A sample `local-values.yaml` file might look like:

```
global:
  storageClass: local-path

postgresql:
  persistence:
    size: 500Mi

ldap:
  password: actual-ldap-password
  username: actual-ldap-username

auth:
  method: google
  google_client_id: actual-google-client-id
  google_client_secret: actual-google-client-secret

email:
  bcc: <your-email-account>@ucsd.edu
  delivery_method: smtp
  host: localhost:3000
  sender: <your-email-account>@ucsd.edu
  smtp_port: 587
pvc:
  email:
    class: local-path
```
