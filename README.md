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

### Development (requires docker compose and make to be installed)

Clone project and navigate to the project directory:
```
git clone --recurse-submodules git@github.com:ZFudge/chocolate-smart-home.git
cd chocolate-smart-home
```

Run the following script to pull external images, build local images, install frontend dependencies, and copy environment variables:
```
./setup-dev.sh
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
