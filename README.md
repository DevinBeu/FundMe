# FundMe Contract

The `FundMe` smart contract is a decentralized crowdfunding platform built on Solidity. It allows users to fund the contract in Ether and provides mechanisms for the owner to withdraw the funds securely. This project also utilizes Chainlink's price feed to ensure that contributions meet a minimum USD threshold.

---

## Features

- **Funding Mechanism**: Users can send Ether to the contract, and their contributions are stored and tracked.
- **Minimum Contribution in USD**: The contract ensures that contributions meet a minimum USD amount (5 USD) using Chainlink's price feeds.
- **Withdrawal Mechanism**: The contract owner can withdraw all funds using two methods: `withdraw` and `cheaperWithdraw`.
- **Ownership Restriction**: Only the owner of the contract can execute withdrawal functions.
- **Fallback and Receive Functions**: Enables seamless funding through direct Ether transfers to the contract.

---

## Prerequisites

- **Solidity Version**: ^0.8.18
- **Dependencies**:
  - Chainlink's AggregatorV3Interface for price feed integration.
  - A deployed Chainlink Price Feed contract address.

---

## Contract Details

### Constructor

Initializes the contract with the following:
- `i_owner`: The address that deploys the contract (owner).
- `s_priceFeed`: A Chainlink price feed contract address passed during deployment.

### Key Functions

1. **Funding Functions**:
   - `fund`: Allows users to send Ether to the contract. Verifies if the contribution meets the minimum USD requirement.
   - `fallback` and `receive`: Support funding through direct Ether transfers.

2. **Owner-Only Functions**:
   - `withdraw`: Allows the owner to withdraw all funds by resetting funders' balances and transferring the contract's Ether balance.
   - `cheaperWithdraw`: Optimized version of the `withdraw` function for reduced gas consumption.

3. **View Functions**:
   - `getVersion`: Returns the version of the price feed being used.
   - `getAddressToAmountFunded`: Retrieves the amount funded by a specific address.
   - `getFunder`: Retrieves the address of a funder by index.
   - `getOwner`: Returns the owner of the contract.

### Modifiers

- **onlyOwner**: Restricts access to certain functions to the contract owner.

---

## Deployment Steps

1. Deploy the contract with a valid Chainlink price feed address (e.g., ETH/USD price feed).
2. Ensure the deploying account is funded with sufficient Ether for deployment.

---

## Usage

1. **Funding the Contract**:
   - Call the `fund` function or send Ether directly to the contract address.

2. **Checking Funders**:
   - Use `getAddressToAmountFunded` to check the contribution of a specific address.
   - Use `getFunder` to retrieve a funder's address by index.

3. **Withdrawing Funds**:
   - Call `withdraw` or `cheaperWithdraw` as the contract owner.

---

## Security Considerations

- **Access Control**: Only the owner can withdraw funds.
- **Fallback Protection**: Proper fallback and receive function implementation prevent accidental Ether loss.
- **Validation**: Contributions are validated using Chainlink's secure price feed.

---

## Future Improvements

- Add support for **events** for better tracking of funding and withdrawal activities.
- Implement **enumerations** and **try/catch** for more robust functionality.
- Explore advanced topics like **Yul/Assembly** for further gas optimization.

---

## License

This project is licensed under the MIT License.
