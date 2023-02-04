pragma solidity ^0.8.0;

contract LotteryBetting {
    // Define the structure for a ticket
    struct Ticket {
        uint256 id;
        address owner;
        uint256 number;
    }

    // Store the list of tickets
    Ticket[] public tickets;

    // Store the jackpot amount
    uint256 public jackpot;

    // Store the number of tickets sold
    uint256 public ticketCount;

    // Store the number of tickets required to play the lottery
    uint256 public ticketLimit;

    // Store the block number when the lottery will be resolved
    uint256 public resolveBlock;

    // Event for logging a new ticket purchase
    event NewTicket(address owner, uint256 ticketId, uint256 ticketNumber);

    // Event for logging the resolution of the lottery
    event ResolveLottery(uint256 winningTicketId, address winner);

    // Function to purchase a ticket
    function purchaseTicket(uint256 number) public payable {
        // Check if the ticket limit has been reached
        require(ticketCount < ticketLimit, "The ticket limit has been reached.");

        // Check if the number is unique
        for (uint256 i = 0; i < tickets.length; i++) {
            require(tickets[i].number != number, "This number has already been taken.");
        }

        // Increment the ticket count
        ticketCount++;

        // Add the ticket to the list of tickets
        tickets.push(Ticket(tickets.length, msg.sender, number));

        // Update the jackpot
        jackpot += msg.value;

        // Emit the NewTicket event with the details of the ticket purchase
        emit NewTicket(msg.sender, tickets.length - 1, number);
    }

    // Function to resolve the lottery
    function resolveLottery() public {
        // Check if the resolve block has been reached
        require(block.number >= resolveBlock, "The resolve block has not been reached.");

        // Pick a random winning ticket
        uint256 winningTicketId = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % ticketCount;

        // Get the winning ticket
        Ticket storage winningTicket = tickets[winningTicketId];

        // Transfer the jackpot to the winner
        winningTicket.owner.transfer(jackpot);

        // Emit the ResolveLottery event with the details of the winner
        emit ResolveLottery(winningTicketId, winningTicket.owner);
    }

    // Function to allow the contract owner to withdraw the remaining balance
    function withdraw() public {
        // Check if the caller is the contract owner
        require(msg.sender == owner, "Only the contract owner can call this function.");

        // Transfer the remaining balance to the contract owner
        msg.sender.transfer(address(this).balance);
    }
}


//This contract allows players to purchase tickets for a lottery, with a unique number for each ticket. The lottery is resolved by selecting a random ticket as the winner, and transferring the jackpot amount to the winner's address. Additionally, the contract has a function to allow the contract owner to withdraw the remaining balance.



