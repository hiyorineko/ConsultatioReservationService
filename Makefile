ARGS := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
up:
	docker compose up
build:
	docker compose build --no-cache --force-rm
init:
	@make build
	docker compose run web cp .env.example .env
	docker compose run web cp .env.example .env.testing
setup:
	docker compose exec web rails db:create
	docker compose exec web rails db:migrate
	docker compose exec web rails db:seed
	docker compose exec web rails webpacker:install
	docker compose exec web rails webpacker:compile
	docker compose exec web rails db:create RAILS_ENV=test
	docker compose exec web rails db:migrate RAILS_ENV=test
remake:
	@make destroy
	@make init
stop:
	docker compose stop
down:
	docker compose down --remove-orphans
restart:
	@make down
	@make up
destroy:
	docker compose down --rmi all --volumes --remove-orphans
destroy-volumes:
	docker compose down --volumes --remove-orphans
ps:
	docker compose ps
logs:
	docker compose logs
logs-watch:
	docker compose logs --follow
log-web:
	docker compose logs web
log-web-watch:
	docker compose logs --follow web
log-db:
	docker compose logs db
log-db-watch:
	docker compose logs --follow db
web:
	docker compose exec web bash
db:
	docker compose exec db bash
sql:
	docker compose exec db bash -c 'mysql -u $$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE'
