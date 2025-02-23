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
	@$(MAKE) -C backend startmqtt
	
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
.PHONY: dev
dev:
	@docker compose -f docker-compose-dev.yml up -d --build --force-recreate

.PHONY: down
down:
	@docker compose -f docker-compose-dev.yml down

.PHONY: all
all: network mqtt backend frontend

.PHONY: shell-be
shell-be:
	@$(MAKE) -C backend shell

.PHONY: shell-fe
shell-fe:
	@$(MAKE) -C frontend shell
