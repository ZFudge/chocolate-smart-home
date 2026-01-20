# Chocolate Smart Home 🍫🏠

An extensible smart home platform that enables integration of custom IoT devices and clients through a plugin-based architecture.

## Project Components

### Backend Service
[![API Status](https://img.shields.io/badge/API-Active-success)](https://github.com/ZFudge/chocolate-smart-home-backend)

A Fast API-powered backend that handles device communication and client requests.
- [Backend Repository](https://github.com/ZFudge/chocolate-smart-home-backend)

### Frontend Application
[![Frontend Status](https://img.shields.io/badge/Frontend-Active-success)](https://github.com/ZFudge/chocolate-smart-home-frontend)

A React-based web interface for device control and monitoring.
- [Frontend Repository](https://github.com/ZFudge/chocolate-smart-home-frontend)

### Microcontroller Integration
[![Microcontroller Status](https://img.shields.io/badge/Microcontrollers-Active-success)](https://github.com/ZFudge/chocolate-smart-home-microcontrollers)

Libraries and examples for integrating various microcontroller-based devices.
- [Microcontroller Repository](https://github.com/ZFudge/chocolate-smart-home-microcontrollers)

### Websocket Service
[![Websocket Status](https://img.shields.io/badge/Websocket-Active-success)](https://github.com/ZFudge/chocolate-smart-home-websockets)

A websocket service for real-time communication between the frontend and backend.
- [Websocket Repository](https://github.com/ZFudge/chocolate-smart-home-websockets)

### Development
Clone project and run in development mode:
```
git clone --recurse-submodules git@github.com:ZFudge/chocolate-smart-home.git
cd chocolate-smart-home
```

Pull external images:
```
docker compose -f docker-compose-dev.yml pull \
    mqtt \
    csm-frontend-dev \
    csm-postgres-db-dev \
    csm-nginx
```
Build local images:
```
docker compose -f docker-compose-dev.yml build \
    csm-ws-service \
    csm-backend-dev
```

Install frontend dependencies:
```
make install
```
Copy environment variables:
```
cp backend/.env.example backend/.env
```
Start project in development mode:
```
make dev
```
Open http://localhost:15173/ in your browser.


Stop project:
```
make down
```
View logs:
```
make logs
```
View mqtt logs:
```
make mqttlogs
```
Clean project:
```
make clean
```
