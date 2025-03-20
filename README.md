# Aleo Lottery Program

## Overview

This is a decentralized lottery system built on the Aleo blockchain platform. The program allows users to participate in a secure and transparent lottery using either public or private transactions, with support for both Aleo credits and custom tokens.

## Features

- **Dual Payment Options**: Participate using Aleo credits or custom tokens
- **Public and Private Transactions**: Choose between public and private transactions for lottery entry
- **Multiple Lottery Entries**: Submit up to 5 lottery number combinations at once
- **Random Number Generation**: Secure random number generation for winner selection
- **Prize Tiers**: Configurable prize tiers based on matching numbers
- **Admin Controls**: Admin features for managing the lottery operation

## How It Works

### Lottery Structure

Each lottery entry consists of:
- 5 rows of lottery numbers
- Each row contains 5 numbers
- Each number must be between 0 and 32

### Participating in the Lottery

1. Choose your lottery numbers (5 sets of 5 numbers)
2. Select a day (lottery round) to participate in
3. Pay the required amount (either in Aleo credits or custom tokens)
4. Receive a Lottery record as proof of participation

### Winning Mechanism

1. The admin generates winning numbers for a specific day
2. Players can match their lottery record against the winning numbers
3. Points are awarded based on how many numbers match in each row
4. Players can claim their prizes based on the accumulated points

## Main Functions

### Admin Functions

- `initialize`: Set up the lottery with an admin and initial price
- `set_winning_price`: Configure prize tiers
- `set_token_price`: Set the price for participation using custom tokens
- `transfer_ownership`: Transfer admin rights to a new address
- `generate_winner`: Generate the winning numbers for a specific day
- `pause` / `unpause`: Control the operational status of the lottery
- `withdraw`: Allow the admin to withdraw funds

### User Functions

- `buy_public`: Purchase lottery tickets using public credits
- `buy_private`: Purchase lottery tickets using private credits
- `buy_public_token`: Purchase lottery tickets using public tokens
- `buy_private_token`: Purchase lottery tickets using private tokens
- `match_lottery`: Check a lottery record against winning numbers
- `claim`: Claim prizes based on points earned

## Technical Details

### Records and Structs

- `Lottery`: A record representing a user's lottery entry
- `LotteryHash`: A struct used for hashing lottery numbers with the day

### Mappings

- `is_available`: Tracks which lottery numbers have been chosen
- `winner_number`: Stores winning numbers for each day
- `user_balance`: Tracks user prize balances
- `user_token_balance`: Tracks user token balances
- `cuurent_amount`: Stores the current price in credits
- `current_amount_token`: Stores the current price in tokens
- `admin`: Stores the admin address
- `status`: Tracks whether the lottery is paused or active
- `winning_price`: Stores the prize amounts for different tiers

## Getting Started

### Prerequisites

- Aleo SDK
- An Aleo account with sufficient credits

### Installation

1. Clone the lottery program repository
2. Build the program using the Aleo SDK
3. Deploy the program to the Aleo network

### Initialization

```bash
aleo run initialize [your_address] [ticket_price]
```

### Setting Prize Tiers

```bash
aleo run set_winning_price [prize_array]
```

### Buying Tickets (Public)

```bash
aleo run buy_public [amount_array] [lottery_numbers] [day]
```

## Security Considerations

- The program uses BHP256 hashing for lottery number verification
- All critical functions include proper authorization checks
- The ChaCha random number generator is used for winner selection

## Limitations

- Numbers are limited to the range 0-32
- Maximum of 5 lottery rows per entry
- Admin must generate winning numbers for each day

## License

[Your License Information]

## Contributors

[Your Contributor Information]
