pragma solidity ^0.8.0;

contract HorseBetting {
    // Define the structure for a horse
    struct Horse {
        uint256 id;
        string name;
        uint256 odds;
    }

    // Store the list of horses
    Horse[] horses;

    // Store the bet amount for each horse
    mapping (uint256 => uint256) public bets;

    // Store the total bet amount for each horse
    uint256[] public totalBets;

    // Store the total amount of ether in the contract
    uint256 public contractBalance;

    // Event for logging a new bet
    event NewBet(address bettor, uint256 horseId, uint256 betAmount);

    // Function to add a new horse
    function addHorse(uint256 id, string memory name, uint256 odds) public {
        horses.push(Horse(id, name, odds));
    }

    // Function to place a bet
    function placeBet(uint256 horseId, uint256 betAmount) public payable {
        // Check if the horse with the given id exists
        require(horseId < horses.length, "Invalid horse id.");

        // Update the bet amount for the given horse
        bets[horseId] += betAmount;

        // Update the total bet amount for the given horse
        totalBets[horseId] += betAmount;

        // Update the contract balance
        contractBalance += betAmount;

        // Emit the NewBet event with the details of the bet
        emit NewBet(msg.sender, horseId, betAmount);
    }

    // Function to resolve the bet and pay out the winnings
    function resolveBet() public {
        // Check if there is only one horse with the highest total bet amount
        uint256 winningHorseId = 0;
        uint256 highestTotalBet = 0;
        for (uint256 i = 0; i < horses.length; i++) {
            if (totalBets[i] > highestTotalBet) {
                highestTotalBet = totalBets[i];
                winningHorseId = i;
            } else if (totalBets[i] == highestTotalBet) {
                // If there is a tie, set the winning horse id to 0
                winningHorseId = 0;
            }
        }

        // Check if a winning horse was found
        require(winningHorseId != 0, "There was a tie. No winning horse.");

        // Calculate the payouts for each bettor
        for (uint256 i = 0; i < horses.length; i++) {
            if (i == winningHorseId) {
                // Calculate the payout for each bettor who bet on the winning horse
                uint256 payouts = totalBets[i] * horses[i].odds;
                for (uint256 j = 0; j < bets.length; j++) {
                    if (bets[j] > 0 && j == i) {
                        address bettor = address(j);
                        bettor.transfer(payouts / totalBets[i]);
                    }
                }
            }
        }
    }
}

//This contract allows players to place bets on different horses, and resolves the bet by determining the horse with the highest total bet amount.
