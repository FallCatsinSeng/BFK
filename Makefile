.PHONY: help up down build logs restart backend-logs db-shell

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

up: ## Start all services (Go API + PostgreSQL + Redis)
	docker compose up -d --build

down: ## Stop all services
	docker compose down

build: ## Rebuild all containers
	docker compose build --no-cache

logs: ## Show all logs
	docker compose logs -f

restart: ## Restart all services
	docker compose restart

backend-logs: ## Show only backend logs
	docker compose logs -f api

db-shell: ## Open psql shell into the database
	docker compose exec postgres psql -U bfk_user -d bfk_db

redis-cli: ## Open redis-cli
	docker compose exec redis redis-cli

clean: ## Remove all containers, volumes, and networks
	docker compose down -v --remove-orphans
