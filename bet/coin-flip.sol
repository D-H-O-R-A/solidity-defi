pragma solidity ^0.8.0;

contract Bet {
    // Define the two players involved in the bet
    address player1;
    address player2;

    // Store the bet amounts of both players
    uint256 player1Bet;
    uint256 player2Bet;

    // Store the outcome of the coin flip
    bool coinFlipResult;

    // Event for logging the outcome of the coin flip
    event CoinFlip(bool result);

    // Function to place a bet
    function placeBet(uint256 betAmount) public payable {
        // Check if the caller of the function is player1
        if (msg.sender == player1) {
            player1Bet = betAmount;
        } else if (msg.sender == player2) {
            player2Bet = betAmount;
        } else {
            // If the caller is neither player1 nor player2, throw an error
            revert();
        }
    }

    // Function to flip the coin and resolve the bet
    function flipCoin() public {
        // Ensure that both players have placed their bets
        require(player1Bet > 0 && player2Bet > 0, "Both players must place their bets first.");

        // Flip the coin
        coinFlipResult = (bool)(uint8(keccak256(abi.encodePacked(now))) % 2);

        // Emit the CoinFlip event with the result of the coin flip
        emit CoinFlip(coinFlipResult);

        // Pay out the winnings to the winner
        if (coinFlipResult) {
            player2.transfer(player2Bet * 2);
        } else {
            player1.transfer(player1Bet * 2);
        }
    }
}


//This contract allows two players to place their bets and then resolves the bet by flipping a virtual coin. The placeBet function checks if the caller of the function is either player1 or player2 and stores their bet amounts accordingly. The flipCoin function performs the coin flip, emits an event with the result, and pays out the winnings to the winner.
