TRASH_PATH := /tmp/null
NETWORK_NAME := chocolate-smart-home-network


.PHONY: help
help:
	@echo "Usage: make TARGET"
	@echo ""
	@echo "Targets:"
	@echo "  help                         Print this help message"
	@echo ""
	@echo "  network                      Create externally managed network"
	@echo "  dev                          Run app in dev mode"
	@echo "  down                        Stop all containers"
	@echo ""
	@echo "Backend:"
	@echo "  mqtt                         Create mqtt container"
	@echo "  backend                      Run backend app and db containers"
	@echo ""
	@echo "Frontend:"
	@echo "  frontend                     Start frontend dev server"
	@echo "  storybook                    Start storybook"
	@echo "  static                       Build static files"
	@echo ""


.PHONY: network
network:
	@${MAKE} -C backend network \
		2> ${TRASH_PATH} || true

.PHONY: logs
logs:
	@docker compose -f docker-compose-dev.yml logs -f

# Frontend
.PHONY: storybook
storybook:
	@$(MAKE) -C frontend storybook

.PHONY: frontend
frontend:
	@$(MAKE) -C frontend run

.PHONY: static
static:
	@$(MAKE) -C frontend build


# Backend
.PHONY: mqtt
mqtt:
	@$(MAKE) -C backend mqtt
	
.PHONY: backend
backend:
	@$(MAKE) -C backend run

.PHONY: broadcast
broadcast:
	@$(MAKE) -C backend broadcast

.PHONY: mqttlogs
mqttlogs:
	@$(MAKE) -C backend mqttlogs

.PHONY: build
build:
	@docker compose -f docker-compose-dev.yml build


# Dev
.PHONY: dev-up
dev-up:
	@docker compose -f docker-compose-dev.yml up -d --remove-orphans

.PHONY: down
down:
	@docker compose -f docker-compose-dev.yml down

.PHONY: dev
dev: down dev-up logs

.PHONY: clean
clean:
	@docker compose -f docker-compose-dev.yml down
	@docker network rm ${NETWORK_NAME}

.PHONY: shell-be
shell-be:
	@docker-compose -f docker-compose-dev.yml exec csm-fastapi-server-dev sh

.PHONY: repl
repl:
	@docker-compose -f docker-compose-dev.yml exec csm-fastapi-server-dev \
		sh -c "pipenv run python -i src/main.py"

.PHONY: shell-fe
shell-fe:
	@docker-compose -f docker-compose-dev.yml exec csm-frontend-dev sh

.PHONY: shell-vcs
shell-vcs:
	@docker-compose -f docker-compose-dev.yml exec virtual-clients sh

.PHONY: shell-postgres
shell-postgres:
	@docker-compose -f docker-compose-dev.yml exec csm-postgres-db-dev sh
