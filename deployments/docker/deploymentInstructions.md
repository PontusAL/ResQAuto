Run app
`docker compose -f deployments/docker/docker-compose.yml up -d --build`

Double check logs
`docker compose -f deployments/docker/docker-compose.yml logs -f qa`

Stop
`docker compose -f deployments/docker/docker-compose.yml down`