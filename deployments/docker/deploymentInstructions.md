Run app
`docker compose -f deployments/docker/docker-compose.yml up -d --build`

Double check logs
`docker compose -f deployments/docker/docker-compose.yml logs -f qa`

Stop
`docker compose -f deployments/docker/docker-compose.yml down`

_Doesn't work_ ? Try running this first:
```sh
deployments/docker/entrypoint.sh
```