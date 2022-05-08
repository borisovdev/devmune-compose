# Remune compose

## Startup

### Build services

```sh
docker-compose --file ./docker-compose.yml --file ./compose-local.yml --env-file ./.env.local build
```

### Up services

```sh
docker-compose --file ./docker-compose.yml --file ./compose-local.yml --env-file ./.env.local up --remove-orphans
```

## Setup for Localnet

### Chainlink node

.api - file, that contains username and password for login to UI.
.password - file, that should contains same mnemonic for hd wallet, which uses by eth-blockchain services

### Contracts workbench

Use devmune-contracts-workbench repository README for setup contracts for interaction with chainlink node.

## Troubleshooting

- On localnet, chainlink node account balance display "-".
Something went wrong. Try to remove db-chainlink-node and chainlink-node service containers and up services with docker-compose. Be careful, all data in database been remove. If chainlink node contain jobs, make sure you made backup.

## Under development notes

In chainlink-node service, .password file use password is same to mnemonic property for startup eth-blockchain service. This is development temporary solve.
