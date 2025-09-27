CSM_NETWORK := csm-network
TRASH_PATH := /tmp/null

.PHONY: help
help:
	@echo "Usage: make TARGET"
	@echo ""
	@echo "Targets:"
	@echo "  help                         Print this help message"
	@echo ""
	@echo "  network                      Create externally managed network"
	@echo "  build                        Build app image"
	@echo "  dev                          Run app in dev mode"
	@echo "  down                         Stop all containers"
	@echo ""
	@echo "Backend:"
	@echo "  mqtt                         Create mqtt container"
	@echo "  backend                      Run backend app and db containers"
	@echo "  testbe                       Run backend tests"
	@echo ""
	@echo "Frontend:"
	@echo "  install                      Install dependencies"
	@echo "  frontend                     Start frontend dev server"
	@echo "  storybook                    Start storybook"
	@echo "  static                       Build static files"
	@echo ""


.PHONY: network
network:
	@${MAKE} -C backend network \
		2> ${TRASH_PATH} || true

.PHONY: logs-dir
logs-dir:
	@mkdir -p $(shell pwd)/logs \
		2> ${TRASH_PATH} || true

.PHONY: logs
logs:
	@docker compose -f docker-compose-dev.yml logs -f

# Frontend
.PHONY: storybook
storybook:
	@docker compose -f docker-compose-dev.yml exec -d csm-frontend-dev sh -c \
		"npm run storybook"
	@docker compose -f docker-compose-dev.yml logs -f csm-frontend-dev

.PHONY: frontend
frontend:
	@$(MAKE) -C frontend run

.PHONY: install
install:
	@$(MAKE) -C frontend install

.PHONY: static
static:
	@$(MAKE) -C frontend static

.PHONY: testfe
testfe:
	@docker compose -f docker-compose-dev.yml \
		exec csm-frontend-dev \
		sh -c "npm run test"

.PHONY: testbe
testbe:
	@$(MAKE) -C backend test


# Backend
.PHONY: mqtt
mqtt:
	@$(MAKE) -C backend mqtt \
		2> ${TRASH_PATH} || true
	@docker start mqtt \
		2> ${TRASH_PATH} || true

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
	@docker-compose -f docker-compose-dev.yml build csm-backend-dev


# Dev
.PHONY: setup-backend-test-db
setup-backend-test-db:
	@$(MAKE) -C backend testdb

.PHONY: run-dev
run-dev:
	@docker compose -f docker-compose-dev.yml up -d

.PHONY: down
down:
	@docker compose -f docker-compose-dev.yml down \
		--remove-orphans \
		2> ${TRASH_PATH} || true
	@docker volume rm csm-postgres-vol || true

.PHONY: clean
clean: down

.PHONY: dev
dev: down logs-dir network mqtt run-dev setup-backend-test-db logs

.PHONY: shell-be
shell-be:
	@docker-compose -f docker-compose-dev.yml \
		exec csm-backend-dev ash -l

.PHONY: repl
repl:
	@docker-compose -f docker-compose-dev.yml exec csm-backend-dev sh -c \
		"pipenv run python -i src/main.py"

.PHONY: shell-fe
shell-fe:
	@docker-compose -f docker-compose-dev.yml exec csm-frontend-dev sh

.PHONY: shell-vcs
shell-vcs:
	@docker-compose -f docker-compose-dev.yml exec virtual-clients sh

.PHONY: shell-postgres
shell-postgres:
	@docker-compose -f docker-compose-dev.yml exec csm-postgres-db-dev sh
