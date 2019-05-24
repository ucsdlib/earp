#!/bin/sh
usage()
{
    echo "usage: ./bin/docker-helper [[[-p] [[-r] | [-s] | [-t]]] | [-h]]"
    echo "Options:"
    echo "-p, --prod    Run production environment using the production Dockerfile. Development used by default"
    echo "-r, --rm      Remove existing containers and volumes. Good for clean starting point"
    echo "-s, --seed    Seed the database with Employee data from LDAP/AD"
    echo "-t, --tests   Run full test suite. Do not use this with -p/--prod"
    echo "-h, --help    Help information you're reading now"
}

compose_env="./docker/development/"
remove_containers_and_volumes=
run_tests=
seed_database=

# take prod option, default to development
# take remove volume option, default to 0 or nothing?
while [ "$1" != "" ]; do
    case $1 in
        -p | --prod )           compose_env="./docker/production/"
                                ;;
        -r | --rm )             remove_containers_and_volumes=1
                                ;;
        -s | --seed )           seed_database=1
                                ;;
        -t | --tests )          run_tests=1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
    esac
    shift
done
# support remove option
if [ "$remove_containers_and_volumes" = "1" ]; then
  # clear out existing data
  docker-compose -f "${compose_env}docker-compose.yml" rm -v
  exit
fi

if [ "$run_tests" = "1" ]; then
  docker-compose -f "./docker/test/docker-compose.yml" build && docker-compose -f "./docker/test/docker-compose.yml" up
elif [ "$seed_database" = "1" ]; then
  docker-compose -f "${compose_env}docker-compose.yml" exec web bundle exec rake db:seed
else
  # build and start production image
  docker-compose -f "${compose_env}docker-compose.yml" build && docker-compose -f "${compose_env}docker-compose.yml" up
fi
