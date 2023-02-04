pragma solidity ^0.8.0;

contract RouletteBetting {
    // Define the structure for a bet
    struct Bet {
        uint256 id;
        address owner;
        uint256 number;
        uint256 amount;
    }

    // Store the list of bets
    Bet[] public bets;

    // Store the pot amount
    uint256 public pot;

    // Store the block number when the roulette will be resolved
    uint256 public resolveBlock;

    // Event for logging a new bet
    event NewBet(address owner, uint256 betId, uint256 betNumber, uint256 betAmount);

    // Event for logging the resolution of the roulette
    event ResolveRoulette(uint256 winningNumber, uint256[] winningBets);

    // Function to place a bet
    function placeBet(uint256 number) public payable {
        // Check if the betting period has ended
        require(block.number < resolveBlock, "The betting period has ended.");

        // Add the bet to the list of bets
        bets.push(Bet(bets.length, msg.sender, number, msg.value));

        // Update the pot
        pot += msg.value;

        // Emit the NewBet event with the details of the bet
        emit NewBet(msg.sender, bets.length - 1, number, msg.value);
    }

    // Function to resolve the roulette
    function resolveRoulette() public {
        // Check if the resolve block has been reached
        require(block.number >= resolveBlock, "The resolve block has not been reached.");

        // Pick a random winning number
        uint256 winningNumber = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 37;

        // Store the list of winning bets
        uint256[] memory winningBets = new uint256[](0);

        // Iterate over the list of bets to find the winning bets
        for (uint256 i = 0; i < bets.length; i++) {
            if (bets[i].number == winningNumber) {
                winningBets.push(i);
            }
        }

        // Calculate the winnings for each winning bet
        uint256 winnings = pot / winningBets.length;

        // Transfer the winnings to each winner
        for (uint256 i = 0; i < winningBets.length; i++) {
            bets[winningBets[i]].owner.transfer(winnings);
        }

        // Emit the ResolveRoulette event with the details of the winning number and bets
        emit ResolveRoulette(winningNumber, winningBets);
    }

    // Function to allow the contract owner to withdraw the remaining balance
    function withdraw() public {
        // Check if the caller is the contract owner
        require(msg.sender == owner, "Only the contract owner can call this function.");

        // Transfer the remaining balance to the contract owner
        msg.sender.transfer(address(this).balance);
    }
}

//This contract allows players to place bets on numbers for a roulette game, with the option to bet on any number from 0 to 36. The roulette
