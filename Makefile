# Makefile for common High Five! development tasks

menu:
	@echo 'build: Run docker-compose build for the current ENV (development, production)'
	@echo 'clean: Run docker-compose down -v for the current ENV (development, production)'
	@echo 'seed: Run docker-compose up for the development environment'
	@echo 'test: Run full rspec test suite using RAILS_ENV=test'
	@echo 'up: Run docker-compose up for the current ENV (development, production)'

build:
	@echo 'Building docker-compose environment'
	@UID=${UID} GID=${GID} docker-compose build

clean:
	@echo 'Cleaning out docker-compose environment'
	@UID=${UID} GID=${GID} docker-compose down -v

seed:
	@echo 'Seeding database with sample data'
	@UID=${UID} GID=${GID} docker-compose exec web bundle exec rake db:seed

test:
	@echo 'Running full test suite'
	@UID=${UID} GID=${GID} docker-compose exec -e RAILS_ENV=test web bundle exec rake db:create db:schema:load
	@UID=${UID} GID=${GID} docker-compose exec -e RAILS_ENV=test web bundle exec rake spec

up:
	@echo 'Bringing up docker-compose environment'
	@UID=${UID} GID=${GID} docker-compose up
