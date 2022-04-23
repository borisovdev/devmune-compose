## Up service 

```sh
docker-compose --file ./docker-compose.yml --file ./compose-dev.yml up --remove-orphans
```

## Under development notes

In chainlink-node service, .password file use password is same to mnemonic property for startup eth-blockchain service. This is development temporary solve.
