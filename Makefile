CSM_NETWORK := csm-network
TRASH_PATH := /tmp/null

.PHONY: help
help:
	@echo "Usage: make TARGET"
	@echo ""
	@echo "Targets:"
	@echo "  help                         Print this help message"
	@echo ""
	@echo "  build                        Build app image"
	@echo "  logs                         Attach to app logs"
	@echo "  dev                          Run app in dev mode"
	@echo "  clean                        Stop and remove all containers"
	@echo ""
	@echo "Backend:"
	@echo "  test-be                      Run backend tests"
	@echo "  testdb                      Run backend test database"
	@echo "  shell-be                     Open backend shell"
	@echo "  black                        Format backend code"
	@echo ""
	@echo "Frontend:"
	@echo "  install                      Install dependencies"
	@echo "  frontend                     Start frontend dev server"
	@echo "  static                       Build static files"
	@echo "  test-fe                       Run FE tests"
	@echo ""
	@echo "MQTT:"
	@echo "  mqttlogs                     Attach to MQTT logs"
	@echo ""

logsdir:
	@mkdir /tmp/logs 2>> /dev/null && touch /tmp/logs/mosquitto.log 2>> /dev/null || true

.PHONY: build
build:
	@docker-compose -f docker/docker-compose-dev.yml build csm-backend-dev

.PHONY: clean
clean:
	@docker compose -f docker/docker-compose-dev.yml down \
		--remove-orphans || true

.PHONY: run-dev
run-dev:
	@docker compose -f docker/docker-compose-dev.yml up -d

.PHONY: devclean
devclean:
	@docker compose -f docker/docker-compose-dev.yml down

.PHONY: devlogs
devlogs:
	@docker compose -f docker/docker-compose-dev.yml logs -f \
      csm-backend-dev \
      virtual-clients \
	  csm-ws-service-dev \
	  csm-scheduler-dev

.PHONY: dev
dev: devclean logsdir
	@docker compose -f docker/docker-compose-dev.yml up -d
	@make testdb
	@make devlogs

# Frontend
.PHONY: install
install:
	@$(MAKE) -C frontend install

.PHONY: static
static:
	@$(MAKE) -C frontend static

.PHONY: test-fe
test-fe:
	@$(MAKE) -C frontend test || \
	docker compose -f docker/docker-compose-dev.yml exec csm-frontend-dev sh -c "npm run test" || true

.PHONY: shell-fe
shell-fe:
	@docker-compose -f docker/docker-compose-dev.yml exec csm-frontend-dev sh

.PHONY: prettier
prettier:
	@$(MAKE) -C frontend prettier

# MQTT
.PHONY: mqttlogs
mqttlogs:
	@docker compose -f docker/docker-compose-dev.yml logs -f csm-mosquitto-dev

# Backend
.PHONY: shell-be
shell-be:
	@docker-compose -f docker/docker-compose-dev.yml \
		exec csm-backend-dev ash -l || \
	$(MAKE) -C backend shell

.PHONY: test-be
test-be:
	@$(MAKE) -C backend test || \
	docker compose -f docker/docker-compose-dev.yml exec csm-backend-dev ash -l -c \
	'pytest' || true


.PHONY: coverage-main
coverage-main:
	@docker compose -f docker/docker-compose-dev.yml exec -it csm-backend-dev ash -l -c \
      'pytest --cov=src --cov-config=tests/.coveragerc --cov-report=term-missing tests/'

.PHONY: coverage-plugins
coverage-plugins:
	@docker compose -f docker/docker-compose-dev.yml exec -it csm-backend-dev ash -l -c \
      'for plugin_name in $$(ls src/plugins/device_plugins/); do . ./scripts/coverage.sh; checkPluginCoverage $$plugin_name; done'

.PHONY: coverage
coverage: testdb coverage-main coverage-plugins


.PHONY: black
black:
	@docker compose -f docker/docker-compose-dev.yml exec csm-backend-dev ash -l -c \
	'black /backend'

.PHONY: testdb
testdb:
	@$(MAKE) -C backend testdb

.PHONY: shell-vcs
shell-vcs:
	@docker-compose -f docker/docker-compose-dev.yml exec virtual-clients sh

.PHONY: shell-ws
shell-ws:
	@docker-compose -f docker/docker-compose-dev.yml exec csm-ws-service-dev sh

.PHONY: shell-db
shell-db:
	@docker-compose -f docker/docker-compose-dev.yml exec csm-postgres-db-dev sh
