# Social-Entropy-Ethereum
A smart contract concept that utilizes the idea that nobody can accurately predict the actions of humans.

# Social Entropy RNG Smart Contract

## Overview

The Social Entropy RNG (Random Number Generator) Smart Contract, named `LiquidRNG`, utilizes blockchain data and external entropy sources to generate random numbers. It's implemented in Solidity ^0.8.12 and adheres to the MIT license.

## Contracts

### Context

Provides base functionalities for accessing transaction context, such as sender address and message data.

- **_msgSender()**: Returns the transaction's sender address.
- **_msgData()**: Returns the transaction's data.

### Ownable

Implements ownership management features, restricting certain actions to the contract's owner.

- **owner()**: Returns the current owner's address.
- **onlyOwner**: Modifier to restrict function access to the owner.
- **renounceOwnership()**: Allows the current owner to relinquish control of the contract.
- **transferOwnership(address newOwner)**: Transfers ownership to a new address.
- **_transferOwnership(address newOwner)**: Internal function for ownership transfer.

### Controllable

Extends `Ownable`, adding control management for specified addresses, allowing them to perform certain actions.

- **addController(address _controller)**: Adds a new controller.
- **delController(address _controller)**: Removes a controller.
- **disableController(address _controller)**: Disables a controller.
- **isController(address _address)**: Checks if an address is a controller.
- **relinquishControl()**: A controller can remove themselves.
- **OnlyController**: Modifier that restricts function access to controllers.

### LiquidRNG

The core contract for generating random numbers, utilizing various seeds, block properties, and external addresses.

- **random1(uint256 mod, uint256 demod)** to **random10(uint256 mod, uint256 demod)**: Generate random numbers based on unique seeds and parameters.
- **randomFull()**: Generates a comprehensive random number using multiple entropy sources.
- **requestMixup()**: Modifies randomness parameters to enhance unpredictability. Should be used before every request.
- **setBaseMods(uint256 newMod)**, **globalModAndDeMod(uint256 newMod)**: Adjust the modulus for random number generation.
- **seedChange(uint256 NS1, uint256 NS2, uint256 NS3, uint256 NS4, uint256 NS5)**: Update seeds used in random number generation.
- **resetStepJump(uint256 newStep, uint256 newJump)**: Resets randomness parameters.
- **setExtEnt(uint256 newExEnt)**: Allows controllers to set external entropy sources.

## Security and Ownership

Sensitive actions are protected under `onlyOwner` and `onlyController` modifiers, ensuring that only authorized addresses can modify contract parameters or manage control.

## Usage

Deploy the `RNGconqueror` contract on the Ethereum blockchain to start generating random numbers. Use the `randomX` functions with appropriate parameters for randomness within your applications. Contract owners and controllers have the flexibility to adjust parameters and entropy sources to maintain the robustness of the random number generation process. Replace the EnvEnt address globals with new high-throughput contracts on your chain.

## Conclusion

`RNGconqueror` offers a secure and flexible solution for random number generation on the Ethereum blockchain, leveraging the inherent unpredictability of blockchain data and external entropy sources.
