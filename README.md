# Lottery Game Aleo Program

## Overview
The `lottery_game_puri.aleo` program is a smart contract deployed on the Aleo blockchain that enables users to participate in a lottery game using zero-knowledge proofs. The contract supports both public and private lottery ticket purchases, ensuring transaction privacy while maintaining verifiable fairness through the Aleo platform's zero-knowledge capabilities.

## Deployment
This program is deployed on the Aleo blockchain, leveraging `credits.aleo` for native token transactions to handle ticket purchases and prize distributions.

## Functions

1. `initialize(owner: address, amount: u64) -> Future`
   
   Initializes the contract with an admin address and sets the initial ticket price.

2. `buy_public(amount: [u64; 5], Lottery_number: [[u8; 5]; 5], day: u16) -> (Lottery, Future)`
   
   Allows users to purchase lottery tickets publicly using Aleo credits. The function creates a lottery record containing the chosen numbers and validates the transaction.

3. `buy_private(input_record: credits.aleo/credits, amount: [u64; 5], Lottery_number: [[u8; 5]; 5], day: u16) -> (Lottery, credits.aleo/credits, Future)`
   
   Enables users to privately purchase lottery tickets using Aleo credits while maintaining transaction privacy.

4. `generate_winner(day: u16) -> Future`
   
   Admin-only function that generates a random winning number combination for the specified lottery day using ChaCha random number generation.

5. `match_lottery(input_record: Lottery) -> Future`
   
   Matches a user's lottery ticket against the winning numbers and calculates the winnings based on matched numbers.

6. `claim(amount: u64) -> (credits.aleo/credits, Future)`
   
   Allows users to claim their lottery winnings in Aleo credits based on their accumulated balance.

7. `transfer_ownership(public new_owner: address) -> Future`
   
   Transfers contract ownership to a new admin address.

8. `unpause() -> Future`
   
   Unpauses the contract, allowing lottery ticket purchases.

9. `pause() -> Future`
   
   Pauses the contract, preventing lottery ticket purchases.

10. `withdraw(amount: u64) -> Future`
    
    Allows the admin to withdraw funds from the contract.

## Key Concepts

### Lottery Structure
- Each lottery ticket consists of 5 rows of 5 numbers, with each number ranging from 0 to 31
- Lottery tickets are purchased for specific days
- Winning numbers are generated randomly using the ChaCha algorithm

### Privacy Protection
- Private ticket purchases maintain user anonymity through zero-knowledge proofs
- Transaction amounts and lottery numbers remain confidential
- Winners can claim prizes privately

### Winning Mechanism
- The `compareArray` function matches user numbers against winning numbers
- Points are awarded based on the number of matches
- The `count_points` function calculates the total winnings based on the number of matches

### Administration
- Contract can be paused/unpaused by the admin
- Ownership can be transferred to a new admin
- Admin can withdraw funds from the contract

## Security Features
- Input validation ensures lottery numbers are within valid ranges
- Transaction status checks prevent operations during paused state
- Admin-only functions are protected by address verification
- Random number generation uses the secure ChaCha algorithm
