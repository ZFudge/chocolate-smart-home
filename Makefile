TRASH_PATH := /tmp/null
NETWORK_NAME := chocolate-smart-home-network

help:
	@echo "Usage: make TARGET"
	@echo ""
	@echo "Targets:"
	@echo "  help                         Print this help message"
	@echo ""
	@echo "  network                      Create externally managed network"
	@echo "  dev                          Run frontend and backend containers"
	@echo "  clean                        Stop all containers"
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


network:
	@${MAKE} -C backend network


# Frontend
storybook:
	@$(MAKE) -C frontend storybook

.PHONY: frontend
frontend:
	@$(MAKE) -C frontend run

static:
	@$(MAKE) -C frontend build


# Backend
mqtt:
	@$(MAKE) -C backend mqtt
	
.PHONY: backend
backend:
	@$(MAKE) -C backend run


# Dev
dev: clean backend frontend

clean:
	@$(MAKE) -C backend clean
	@$(MAKE) -C frontend clean

all: network mqtt backend frontend
