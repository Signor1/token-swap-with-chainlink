## Swap with Chainlink

This project implements a swap contract on Ethereum using Chainlink oracles. It allows users to swap between 3 different token pairs (ETH, Link, Dai). Each token should be transferable between the other two tokens.

### Installation and Setup

1. Clone this repository.
2. Install Rust and Foundry if you haven't already. Refer to the [Foundry documentation](https://book.getfoundry.sh/) for installation instructions.

### Usage

#### Build

```shell
$ forge build
```

#### Test

To run tests, use the following command:

```shell
$ forge test --rpc-url https://eth-sepolia.g.alchemy.com/v2/OFbBMdGvMDsq04pqUdIS5xUhyzl7N0JI --evm-version cancun -vvvvv
```

#### Format

```shell
$ forge fmt
```

#### Gas Snapshots

```shell
$ forge snapshot
```

#### Anvil

```shell
$ anvil
```

#### Deploy

```shell
$ forge script script/Swap.s.sol:SwapScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

#### Cast

```shell
$ cast <subcommand>
```

#### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

### Documentation

For more detailed documentation on Foundry and its components, visit the [Foundry Book](https://book.getfoundry.sh/).
