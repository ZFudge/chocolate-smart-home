docker compose -f docker-compose-dev.yml pull \
    mqtt \
    csm-frontend-dev \
    csm-postgres-db-dev \
    csm-nginx

docker compose -f docker-compose-dev.yml build \
    csm-ws-service \
    csm-backend-dev

make install

cp backend/.env.example backend/.env
