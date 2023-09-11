# Team Wallet Smart Contract

![License](https://img.shields.io/badge/license-MIT-blue.svg)

The Team Wallet Smart Contract is a decentralized application (DApp) designed for managing and sharing credits among the team members. This contract provides a secure and transparent way to handle transaction requests, approvals, and rejections within the team.

## Table of Contents
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Functions](#functions)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

## Getting Started

### Prerequisites

Before deploying and using the Team Wallet Smart Contract, ensure you have the following:

- Ethereum Wallet (e.g., MetaMask) to interact with the contract.
- Solidity development environment for contract deployment.
- Winning team members' Ethereum addresses.

### Deployment

1. Deploy the smart contract to the Ethereum blockchain using a development tool or service.

2. Execute the `setWallet` function as the deployer to initialize the contract. Provide an array of winning team members' Ethereum addresses and the initial credits. Ensure the deployer's address is not part of the members' list.

3. The contract is now ready for use by the team members.

## Usage

### Functions

- `setWallet(address[] members, uint credits)`: Initializes the contract with the team members and initial credits. Only accessible by the deployer.

- `spend(uint amount)`: Allows a team member to record a transaction request. Approval is recorded by default. The transaction will be recorded irrespective of the amount, even if it exceeds the available credits.

- `approve(uint n)`: Enables team members to approve a transaction request. Reverts if the member has already approved or rejected the request.

- `reject(uint n)`: Allows team members to reject a transaction request. Reverts if the member has already approved or rejected the request.

- `credits()`: Retrieves the current available credits in the wallet. Accessible only to team members.

- `viewTransaction(uint n)`: Provides details of a specific transaction request, including the amount and status (pending, debited, or failed). Accessible only to team members.

- `transactionStats()`: Returns the count of debited, pending, and failed transaction requests. Accessible only to winning team members.

## Examples

Here are some example usages of the Team Wallet Smart Contract:

- **Setting Up the Wallet:**
  ```solidity
  // Deployer initializes the contract
  setWallet([0xMember1, 0xMember2, 0xMember3], 1000);
- **Recording a Transaction Request:**
  ```solidity
  // Winning team member records a transaction request
  spend(200);
