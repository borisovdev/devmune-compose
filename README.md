# Devmune compose

## Step by step

### Create required files

#### Prod

- ./.env.prod
- ./services/devmune-ui/.env

Place your SSL certs files (fullchain.pem && privkey.pem) to **./certs**

### Build services

#### Local

```sh
docker-compose --file ./docker-compose.yml --file ./compose-local.yml --env-file ./.env.local build
```

#### Prod

```sh
docker-compose --file ./docker-compose.yml --file ./compose-prod.yml --env-file ./.env.prod build
```

### Up services

#### Local

```sh
docker-compose --file ./docker-compose.yml --file ./compose-local.yml --env-file ./.env.local up --remove-orphans
```

#### Prod

```sh
docker-compose --file ./docker-compose.yml --file ./compose-prod.yml --env-file ./.env.prod up --remove-orphans
```

### Integrate with chainlink node

#### Prod

Add new bridge, named as **devmune-ratings-github**.  

CAUTION! Replace contract addresses from devmune job to your **operator contract address**

Add new job to your chainlink node from dir **./services/chainlink-node/jobs/job_bridge_devmune_rating_v2.toml**

Fund your chainlink node account by ETH.  
Fund your operator contract by LINK.
Fund your DevmuneRating contract by LINK.

That's all!

## DEV: Setup for Localnet

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
