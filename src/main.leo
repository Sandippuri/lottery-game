import credits.aleo;
import token_registry.aleo; 

program lottery_game_puri_v004.aleo{

    record Lottery {
        owner: address,
        lottery: [[u8; 5]; 5],
        days: u16,
    }

    struct LotteryHash {
        lottery: [u8; 5],
        day: u16
    }

    mapping is_available: field => bool;
    mapping winner_number: u16 => [u8; 5];

    mapping user_balance: field => u64;
    mapping user_token_balance: field => u64;

    mapping cuurent_amount: bool => u64;
    mapping current_amount_token: field => u128;
    mapping admin: bool => address;
    mapping status: bool => u8;
    mapping winning_price: bool => [u64; 5];

    const UNPAUSED_STATUS: u8 = 1u8;
    const PAUSED_STATUS: u8 = 0u8;
    const first_number_amount: u64= 2u64;

    async transition initialize(owner: address, amount: u64) -> Future {
        assert(amount > 0u64);
        return (finalize_initialize(owner, amount));
    }

    async function finalize_initialize(owner: address, amount:u64){
        assert(admin.contains(true).not());
        admin.set(true, owner);
        cuurent_amount.set(true, amount);
        status.set(true, PAUSED_STATUS);
        let zero : LotteryHash = LotteryHash {
            lottery:[0u8,0u8,0u8,0u8,0u8],
            day: 1u16
        };
        let zero_hash : field = BHP256::hash_to_field(zero);
        is_available.set(zero_hash, true);
    }

    async transition set_winning_price(prize_money: [u64;5]) -> Future {
         return (finalize_set_winning_price(self.caller, prize_money));
    }

    async function finalize_set_winning_price(from:address, amount: [u64;5]) {
        let current_owner: address = admin.get(true);
        assert_eq(from, current_owner);
        winning_price.set(true, amount);

    }

    async transition change_lottery_price(price: u64) -> Future {
        assert(price > 0u64);
        return (finalize_change_lottery_price(self.caller, price));
    }

    async function finalize_change_lottery_price(from: address, price: u64) {
        let current_owner: address = admin.get(true);
        assert_eq(from, current_owner);
        cuurent_amount.set(true, price);
    }

    async transition set_token_price(token_id: field, price: u128) -> Future {
        assert(price > 0u128);
        return (finalize_set_token_price(self.caller, price, token_id));
    }

    async function finalize_set_token_price(owner: address, price:u128, token_id: field){
        assert_eq(admin.get(true), owner);
        current_amount_token.set(token_id, price);
    }

    async transition buy_public(amount: [u64; 5], Lottery_number: [[u8; 5]; 5], day: u16) -> (Lottery, Future) {    
        for i: u8 in 0u8..5u8 {
            for j: u8 in 0u8..5u8 {
                assert(Lottery_number[i][j] <= 32u8);
            }
        } 
        let total_amount: u64 = 0u64;
        for i: u8 in 0u8..5u8 {
            total_amount += amount[i];
        }
        let lottery: Lottery = Lottery {
            owner: self.caller,
            lottery: Lottery_number,
            days: day,
        };

        let Lottery_number_hash1 : field = BHP256::hash_to_field( LotteryHash {
            lottery: Lottery_number[0u8],
            day: day
        });
        let Lottery_number_hash2 : field = BHP256::hash_to_field( LotteryHash {
            lottery: Lottery_number[1u8],
            day: day
        });
        let Lottery_number_hash3 : field = BHP256::hash_to_field( LotteryHash {
            lottery: Lottery_number[2u8],
            day: day
        });
        let Lottery_number_hash4 : field = BHP256::hash_to_field( LotteryHash {
            lottery: Lottery_number[3u8],
            day: day
        });
        let Lottery_number_hash5 : field = BHP256::hash_to_field( LotteryHash {
            lottery: Lottery_number[4u8],
            day: day
        });
        
        let lottery_hashes: [field; 5] = [Lottery_number_hash1, Lottery_number_hash2, Lottery_number_hash3, Lottery_number_hash4, Lottery_number_hash5];
        let transfer_output: Future = credits.aleo/transfer_public_as_signer(self.address, total_amount);

        return (lottery, finalize_buy_public(transfer_output, total_amount, day, lottery_hashes, Lottery_number[0u8]));   
    }

    async function finalize_buy_public(f:Future, total_amount: u64, day: u16, Lottery_number_hash: [field; 5], lottery: [u8; 5]){
        f.await();
        assert_eq(winner_number.contains(day), false);
        assert_eq(status.get(true), UNPAUSED_STATUS);
        assert_eq(total_amount % cuurent_amount.get(true), 0u64);
        let zero_hash : field = BHP256::hash_to_field( LotteryHash {
            lottery:[0u8,0u8,0u8,0u8,0u8],
            day: day
        });
        for i: u8 in 0u8..5u8 {
            if(Lottery_number_hash[i] != zero_hash){
                assert_eq(is_available.contains(Lottery_number_hash[i]), false);
                is_available.set(Lottery_number_hash[i], true);
            }
        }
    }


    async transition buy_public_token(amount: [u128; 5], Lottery_number: [[u8; 5]; 5], day: u16, tokenId: field) -> (Lottery, Future) {    
        for i: u8 in 0u8..5u8 {
            for j: u8 in 0u8..5u8 {
                assert(Lottery_number[i][j] <= 32u8);
            }
        } 
        let total_amount: u128 = 0u128;
        for i: u8 in 0u8..5u8 {
            total_amount += amount[i];
        }
        let lottery: Lottery = Lottery {
            owner: self.caller,
            lottery: Lottery_number,
            days: day
        };

        let Lottery_number_hash1 : field = BHP256::hash_to_field( LotteryHash {
            lottery: Lottery_number[0u8],
            day: day
        });
        let Lottery_number_hash2 : field = BHP256::hash_to_field( LotteryHash {
            lottery: Lottery_number[1u8],
            day: day
        });
        let Lottery_number_hash3 : field = BHP256::hash_to_field( LotteryHash {
            lottery: Lottery_number[2u8],
            day: day
        });
        let Lottery_number_hash4 : field = BHP256::hash_to_field( LotteryHash {
            lottery: Lottery_number[3u8],
            day: day
        });
        let Lottery_number_hash5 : field = BHP256::hash_to_field( LotteryHash {
            lottery: Lottery_number[4u8],
            day: day
        });
        
        let lottery_hashes: [field; 5] = [Lottery_number_hash1, Lottery_number_hash2, Lottery_number_hash3, Lottery_number_hash4, Lottery_number_hash5];
        let transfer_output: Future = token_registry.aleo/transfer_public_as_signer(tokenId, self.address, total_amount);

        return (lottery, finalize_buy_public_token(transfer_output, total_amount, day, lottery_hashes, Lottery_number[0u8], tokenId));   
    }

    async function finalize_buy_public_token(f:Future, total_amount: u128, day: u16, Lottery_number_hash: [field; 5], lottery: [u8; 5], tokenId: field){
        f.await();
        assert_eq(winner_number.contains(day), false);
        assert_eq(status.get(true), UNPAUSED_STATUS);
        assert_eq(total_amount % current_amount_token.get(tokenId), 0u128);
        let zero_hash : field = BHP256::hash_to_field( LotteryHash {
            lottery:[0u8,0u8,0u8,0u8,0u8],
            day: day
        });
        for i: u8 in 0u8..5u8 {
            if(Lottery_number_hash[i] != zero_hash){
                assert_eq(is_available.contains(Lottery_number_hash[i]), false);
                is_available.set(Lottery_number_hash[i], true);
            }
        }
    }


    // mapping amount -> make it dynamic
    async transition buy_private(input_record: credits.aleo/credits, amount: [u64; 5], Lottery_number: [[u8; 5]; 5], day: u16,) -> (Lottery, credits.aleo/credits, Future) {
        for i: u8 in 0u8..5u8 {
            for j: u8 in 0u8..5u8 {
                assert(Lottery_number[i][j] < 32u8);
            }
        } 
        let total_amount: u64 = 0u64;
        for i: u8 in 0u8..5u8 {
            total_amount += amount[i];
        }

        let lottery: Lottery = Lottery {
            owner: self.caller,
            lottery: Lottery_number,
            days: day,
        };
        
        let transfer_output: (credits.aleo/credits, Future) = credits.aleo/transfer_private_to_public(input_record, self.address, total_amount);
        
        let Lottery_number_hash1 : field = BHP256::hash_to_field(Lottery_number[0u8]);
        let Lottery_number_hash2 : field = BHP256::hash_to_field(Lottery_number[1u8]);
        let Lottery_number_hash3 : field = BHP256::hash_to_field(Lottery_number[2u8]);
        let Lottery_number_hash4 : field = BHP256::hash_to_field(Lottery_number[3u8]);
        let Lottery_number_hash5 : field = BHP256::hash_to_field(Lottery_number[4u8]);
        let lottery_hashes: [field; 5] = [Lottery_number_hash1, Lottery_number_hash2, Lottery_number_hash3, Lottery_number_hash4, Lottery_number_hash5];

        return (lottery, transfer_output.0, finalize_buy_private(lottery_hashes, total_amount, transfer_output.1, day));   
    }

    async function finalize_buy_private(Lottery_number_hash: [field; 5], total_amount: u64, f:Future, day: u16){
        f.await();
        assert(winner_number.contains(day).not());
        assert_eq(status.get(true), UNPAUSED_STATUS);
        assert_eq(total_amount % cuurent_amount.get(true), 0u64);
        let zero_hash : field = BHP256::hash_to_field( LotteryHash {
            lottery:[0u8,0u8,0u8,0u8,0u8],
            day: day
        });
        for i: u8 in 0u8..5u8 {
            if(Lottery_number_hash[i] != zero_hash){
                assert(is_available.contains(Lottery_number_hash[i]).not());
                is_available.set(Lottery_number_hash[i], true);
            }
        }
    }

    async transition buy_private_token(input_record: token_registry.aleo/Token, amount: [u64; 5], Lottery_number: [[u8; 5]; 5], day: u16,) -> (Lottery, token_registry.aleo/Token, Future) {
        for i: u8 in 0u8..5u8 {
            for j: u8 in 0u8..5u8 {
                assert(Lottery_number[i][j] < 32u8);
            }
        } 
        let total_amount: u64 = 0u64;
        for i: u8 in 0u8..5u8 {
            total_amount += amount[i];
        }

        let lottery: Lottery = Lottery {
            owner: self.caller,
            lottery: Lottery_number,
            days: day
        };
        
        let transfer_output: (token_registry.aleo/Token, Future) = token_registry.aleo/transfer_private_to_public(self.address, total_amount as u128,input_record);
        
        let Lottery_number_hash1 : field = BHP256::hash_to_field(Lottery_number[0u8]);
        let Lottery_number_hash2 : field = BHP256::hash_to_field(Lottery_number[1u8]);
        let Lottery_number_hash3 : field = BHP256::hash_to_field(Lottery_number[2u8]);
        let Lottery_number_hash4 : field = BHP256::hash_to_field(Lottery_number[3u8]);
        let Lottery_number_hash5 : field = BHP256::hash_to_field(Lottery_number[4u8]);
        let lottery_hashes: [field; 5] = [Lottery_number_hash1, Lottery_number_hash2, Lottery_number_hash3, Lottery_number_hash4, Lottery_number_hash5];

        return (lottery, transfer_output.0, finalize_buy_private_token(lottery_hashes, total_amount, transfer_output.1, day, input_record.token_id));   
    }

    async function finalize_buy_private_token(Lottery_number_hash: [field; 5], total_amount: u64, f:Future, day: u16, tokenId: field){
        f.await();
        assert(winner_number.contains(day).not());
        assert_eq(status.get(true), UNPAUSED_STATUS);
        assert_eq(total_amount as u128 % current_amount_token.get(tokenId), 0u128);
        let zero_hash : field = BHP256::hash_to_field( LotteryHash {
            lottery:[0u8,0u8,0u8,0u8,0u8],
            day: day
        });
        for i: u8 in 0u8..5u8 {
            if(Lottery_number_hash[i] != zero_hash){
                assert(is_available.contains(Lottery_number_hash[i]).not());
                is_available.set(Lottery_number_hash[i], true);
            }
        }
    }

    async transition generate_winner(day: u16) -> Future {
        return (finalize_generate_winner(day, self.caller));
    }

    async function finalize_generate_winner(day: u16, from:address) {
        assert_eq(status.get(true), UNPAUSED_STATUS);
        let current_owner: address = admin.get(true);
        assert_eq(from, current_owner);
        let max_value: u8 = 32u8;
        let first: u8 = ChaCha::rand_u8() % (max_value + 1u8);
        let second: u8 = ChaCha::rand_u8() % (max_value + 1u8);
        let third: u8 = ChaCha::rand_u8() % (max_value + 1u8);
        let fourth: u8 = ChaCha::rand_u8() % (max_value + 1u8);
        let fifth: u8 = ChaCha::rand_u8() % (max_value + 1u8);
        let result: [u8; 5] = [first, second, third, fourth, fifth];
        // set to mapping 
        winner_number.set(day, result);
        let zero_hash : field = BHP256::hash_to_field( LotteryHash {
            lottery:[0u8,0u8,0u8,0u8,0u8],
            day: day
        });
        is_available.set(zero_hash, true);
    }

    async transition match_lottery(input_record: Lottery) -> Future {
        let owner_hash: field = BHP256::hash_to_field(input_record.owner);
        return (finalize_match_lottery(owner_hash, input_record.lottery, input_record.days));
    }

    async function finalize_match_lottery(owner_hash: field, lottery: [[u8; 5]; 5], day: u16) {
        assert(day < day + 7u16);
        assert_eq(status.get(true), UNPAUSED_STATUS);
        let winner_lottery: [u8; 5] = winner_number.get(day);
        let matched_value: [u8; 5] = compareArray(lottery, winner_lottery);
        let prize: [u64; 5] = winning_price.get(true); 
        let total_points: u64 = count_points(matched_value, prize);
        let current_balance: u64 = user_balance.get_or_use(owner_hash, 0u64);
        user_balance.set(owner_hash, total_points);
    }

    async transition claim(amount: u64) -> (credits.aleo/credits, Future) {
        assert(amount > 0u64);
        let winner_hash: field = BHP256::hash_to_field(self.caller);
        let transfer_output: (credits.aleo/credits, Future) = credits.aleo/transfer_public_to_private(self.caller, amount);
        return (transfer_output.0, finalize_claim(winner_hash, amount, transfer_output.1));
    }

    async function finalize_claim(winner_hash: field, amount: u64, transfer_output: Future) {
         transfer_output.await();
         assert(true);
         assert_eq(status.get(true), UNPAUSED_STATUS);
         let winner_balance: u64= user_balance.get(winner_hash);
         assert(winner_balance >= amount);
         user_balance.set(winner_hash, winner_balance-amount);
    }

    async transition transfer_ownership(public new_owner: address) -> Future{
        return (finalize_transfer_ownership(self.caller, new_owner));
    }

    async function finalize_transfer_ownership(from: address, new_owner: address) {
        let current_owner: address = admin.get(true);
        assert_eq(from, current_owner);

        admin.set(true, new_owner);
    }

    async transition unpause() -> Future {
        return( finalize_unpause(self.caller));
    }

    async function finalize_unpause(from: address) {
        let owner: address = admin.get(true);
        assert_eq(from, owner);
        status.set(true, UNPAUSED_STATUS);
    }

    async transition pause() -> Future {
        return( finalize_pause(self.caller));
    }

    async function finalize_pause(from: address) {
        let owner: address = admin.get(true);
        assert_eq(from, owner);
        status.set(true, PAUSED_STATUS);
    }

    async transition withdraw(amount: u64) -> Future{
        let transfer_output: Future = credits.aleo/transfer_public(self.caller, amount);
        return (finalize_withdraw(amount, self.caller, transfer_output));
    }

    async function finalize_withdraw(amount: u64, from: address, f: Future) {
        f.await();
        let owner: address = admin.get(true);
        assert_eq(from, owner);
    }

    inline compareArray(lotteryA: [[u8; 5];5], lotteryB: [u8; 5]) -> [u8;5] {
        let count1: u8 = 0u8;
        let count2: u8 = 0u8;
        let count3: u8 = 0u8;
        let count4: u8 = 0u8;
        let count5: u8 = 0u8;

            for j: u8 in 0u8..5u8 {
                for k: u8 in 0u8..5u8{
                    if lotteryA[0u8][j] == lotteryB[k] {
                        count1 += 1u8;
                    }
                }
            }

            for j: u8 in 0u8..5u8 {
                for k: u8 in 0u8..5u8 {
                    if lotteryA[1u8][j] == lotteryB[k] {
                        count2 += 1u8;
                    }
                }
            }

            for j: u8 in 0u8..5u8 {
                for k: u8 in 0u8..5u8 {
                    if lotteryA[2u8][j] == lotteryB[k] {
                        count3 += 1u8;
                    }
                }
            }

            for j: u8 in 0u8..5u8 {
                for k: u8 in 0u8..5u8 {
                    if lotteryA[3u8][j] == lotteryB[k] {
                        count4 += 1u8;
                    }
                }
            }

            for j: u8 in 0u8..5u8{
                for k:  u8 in 0u8..5u8 {
                    if lotteryA[4u8][j] == lotteryB[k] {
                        count5 += 1u8;
                    }
                }
        }

        return [count1, count2, count3, count4, count5];
    }

    inline count_points(input: [u8; 5], prize: [u64;5]) -> u64 {
        let total_point: u64 = 0u64;
        for i: u8 in 0u8..5u8{
            if input[i] == 1u8 {
                total_point +=prize[0u8];
            }
            else if input[i] == 2u8 {
                total_point +=prize[1u8];
            }
            else if input[i] == 3u8 {
                total_point +=prize[2u8];
            }
            else if input[i] == 4u8 {
                total_point +=prize[3u8];
            }
            else if input[i] == 5u8 {
                total_point +=prize[4u8];
            }
            else {
                total_point +=0u64;            
            }
        }
       return total_point;
    }

}