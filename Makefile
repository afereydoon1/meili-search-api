# =====================================
# Setup & Variables
# =====================================
ifneq (,$(wildcard .env))
  include .env
  export
endif

# Default variables
DOCKER_COMPOSE = docker compose -f ./deploy/docker-compose.yml

# Colors
COLOR_RESET = \033[0m
COLOR_INFO = \033[32m
COLOR_WARN = \033[33m

# =====================================
# Main Commands
# =====================================
up: ## Start all containers
	@echo "$(COLOR_INFO)Starting containers...$(COLOR_RESET)"
	$(DOCKER_COMPOSE) --env-file .env up -d
	@echo "$(COLOR_INFO)Services are ready!$(COLOR_RESET)"

down: ## Stop all containers
	@echo "$(COLOR_WARN)Stopping containers...$(COLOR_RESET)"
	$(DOCKER_COMPOSE) --env-file .env down

restart: down up ## Restart all containers

# =====================================
# Build Commands
# =====================================
build: ## Build all containers with cache
	@echo "$(COLOR_INFO)Building containers...$(COLOR_RESET)"
	$(DOCKER_COMPOSE) build

build-no-cache: ## Build all containers without cache
	@echo "$(COLOR_INFO)Building containers without cache...$(COLOR_RESET)"
	$(DOCKER_COMPOSE) build --no-cache

rebuild: down build up ## Rebuild and restart containers

# =====================================
# Service Commands
# =====================================
app-shell: ## Access the app container's shell
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app sh

worker-shell: ## Access the worker container's shell
	docker exec -it $(COMPOSE_PROJECT_NAME)-worker sh

nginx-shell: ## Access the nginx container's shell
	docker exec -it $(COMPOSE_PROJECT_NAME)-nginx sh

nginx-reload: ## Reload Nginx configuration
	docker exec -it $(COMPOSE_PROJECT_NAME)-nginx nginx -s reload

# =====================================
# Laravel Commands
# =====================================
composer-install: ## Run composer install
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app composer install

composer-update: ## Run composer update in the app container
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app composer update

worker-composer-install: ## Run composer install in the worker container
	docker exec -it $(COMPOSE_PROJECT_NAME)-worker composer install

worker-composer-update: ## Run composer update in the worker container
	docker exec -it $(COMPOSE_PROJECT_NAME)-worker composer update

composer:
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app composer $(cmd)

artisan: ## Run an artisan command passed as cmd variable. Example: make artisan cmd="cache:clear"
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app php artisan $(cmd)

worker-artisan-%: ## Run artisan commands in worker container. Usage: make worker-artisan-horizon
	docker exec -it $(COMPOSE_PROJECT_NAME)-worker php artisan $*

horizon-start: ## Start Laravel Horizon
	docker exec -it $(COMPOSE_PROJECT_NAME)-worker php artisan horizon

horizon-stop: ## Stop Laravel Horizon
	docker exec -it $(COMPOSE_PROJECT_NAME)-worker php artisan horizon:terminate

horizon-status: ## Check Laravel Horizon status
	docker exec -it $(COMPOSE_PROJECT_NAME)-worker php artisan horizon:status

horizon-pause: ## Pause Laravel Horizon
	docker exec -it $(COMPOSE_PROJECT_NAME)-worker php artisan horizon:pause

horizon-continue: ## Continue Laravel Horizon
	docker exec -it $(COMPOSE_PROJECT_NAME)-worker php artisan horizon:continue

migrate: ## Run database migrations
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app php artisan migrate

fresh: ## Refresh database with seeds
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app php artisan scout:delete-all-indexes
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app php artisan scout:sync-index-settings
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app php artisan migrate:fresh --seed
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app php artisan scout:import-all

# =====================================
# Utility Commands
# =====================================
logs: ## View container logs
	$(DOCKER_COMPOSE) --env-file .env logs -f

worker-logs: ## View worker container logs
	$(DOCKER_COMPOSE) --env-file .env logs -f worker

ps: ## Show container status
	$(DOCKER_COMPOSE) --env-file .env ps

# =====================================
# Database Commands (PostgreSQL)
# =====================================
db-shell: ## Access PostgreSQL shell
	docker exec -it $(COMPOSE_PROJECT_NAME)-postgres psql -U $(DB_USERNAME) -d $(DB_DATABASE)

db-root: ## Access PostgreSQL shell as superuser (postgres)
	docker exec -it $(COMPOSE_PROJECT_NAME)-postgres psql -U postgres

db-backup: ## Backup database
	@echo "$(COLOR_INFO)Creating database backup...$(COLOR_RESET)"
	@mkdir -p ../database/backups
	docker exec $(COMPOSE_PROJECT_NAME)-postgres pg_dump -U $(DB_USERNAME) -d $(DB_DATABASE) > ../database/backups/backup-$(shell date +%Y%m%d-%H%M%S).sql

db-restore: ## Restore database from backup file. Usage: make db-restore file=backup-file.sql
	@if [ -z "$(file)" ]; then \
		echo "$(COLOR_WARN)Please specify a backup file: make db-restore file=backup-file.sql$(COLOR_RESET)"; \
		exit 1; \
	fi
	@echo "$(COLOR_INFO)Restoring database from $(file)...$(COLOR_RESET)"
	docker exec -i $(COMPOSE_PROJECT_NAME)-postgres psql -U $(DB_USERNAME) -d $(DB_DATABASE) < ./deploy/docker/postgres/dumps/$(file)

# =====================================
# Cache & Horizon Updates
# =====================================
horizon-reset: horizon-stop ## Reset Laravel Horizon supervisors
	@echo "$(COLOR_INFO)Resetting Horizon supervisors...$(COLOR_RESET)"
	docker exec -it $(COMPOSE_PROJECT_NAME)-worker php artisan horizon:purge
	docker exec -it $(COMPOSE_PROJECT_NAME)-worker php artisan horizon:terminate
	docker exec -it $(COMPOSE_PROJECT_NAME)-worker php artisan horizon

cache-clear: ## Clear Laravel config, route, view, and app caches
	@echo "$(COLOR_WARN)Clearing Laravel caches...$(COLOR_RESET)"
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app php artisan cache:clear
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app php artisan config:clear
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app php artisan route:clear
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app php artisan view:clear
	@echo "$(COLOR_INFO)All caches cleared.$(COLOR_RESET)"

cache-optimize: ## Cache Laravel config, route, view
	@echo "$(COLOR_INFO)Optimizing Laravel caches...$(COLOR_RESET)"
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app php artisan config:cache
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app php artisan route:cache
	docker exec -it $(COMPOSE_PROJECT_NAME)-laravel-app php artisan view:cache
	@echo "$(COLOR_INFO)All caches optimized.$(COLOR_RESET)"

cache-rebuild: cache-clear cache-optimize ## Clear and re-optimize Laravel caches
	@echo "$(COLOR_INFO)Laravel cache rebuild complete.$(COLOR_RESET)"

# =====================================
# Overrides: Install & Clean
# =====================================
install: ## First time setup: build images, start containers, install dependencies, run migrations
	@echo "$(COLOR_INFO)Starting installation...$(COLOR_RESET)"
	@if [ ! -f ../.env ]; then \
		echo "$(COLOR_WARN)Creating .env file...$(COLOR_RESET)"; \
		cp ../.env.example ../.env; \
		echo "UID=$(shell id -u)" >> ../.env; \
		echo "GID=$(shell id -g)" >> ../.env; \
	fi
	@echo "$(COLOR_INFO)Building containers...$(COLOR_RESET)"
	$(MAKE) build
	@echo "$(COLOR_INFO)Starting services...$(COLOR_RESET)"
	$(MAKE) up
	@echo "$(COLOR_INFO)Installing composer dependencies...$(COLOR_RESET)"
	$(MAKE) composer-install
	@echo "$(COLOR_INFO)Running migrations...$(COLOR_RESET)"
	$(MAKE) artisan cmd="migrate --seed"
	@echo "$(COLOR_INFO)Installation complete!$(COLOR_RESET)"

clean: down ## Remove all containers, volumes, and data
	@echo "$(COLOR_WARN)This will remove all containers, volumes, and data. Are you sure? [y/N]$(COLOR_RESET)" && read ans && [ $${ans:-N} = y ]
	docker system prune -f
	docker volume rm $(COMPOSE_PROJECT_NAME)-postgres-data || true

# =====================================
# Help & Defaults
# =====================================
help: ## Show this help
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(COLOR_INFO)%-30s$(COLOR_RESET) %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
.PHONY: install up down restart build build-no-cache rebuild app-shell worker-shell nginx-shell nginx-reload composer-install composer-update worker-composer-install worker-composer-update artisan worker-artisan-% horizon-start horizon-stop horizon-status horizon-pause horizon-continue migrate fresh logs worker-logs ps clean help db-shell db-root db-backup db-restore horizon-reset cache-clear cache-optimize cache-rebuild composer
