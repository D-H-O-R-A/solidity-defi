pragma solidity ^0.8.0;

contract Bingo {
    // Game configuration
    uint256 public constant ticketPrice = 1 ether; // in wei
    uint256 public constant totalTickets = 100;
    uint256 public constant winNumber = 25;
    
    // Game state
    uint256 public ticketsSold;
    mapping (address => uint256) public playerTickets;
    uint256[] public ticketNumbers;
    uint256 public winningTicket;
    bool public gameEnded;
    
    // Events
    event TicketBought(address player, uint256 ticketId);
    event BingoCalled(uint256 winningTicket);
    
    // Modifiers
    modifier onlyBeforeEnd() {
        require(!gameEnded, "The game has already ended.");
        _;
    }
    
    constructor() public {
        for (uint256 i = 0; i < totalTickets; i++) {
            ticketNumbers.push(i);
        }
    }
    
    function buyTicket() public payable onlyBeforeEnd {
        require(msg.value == ticketPrice, "Incorrect ticket price.");
        require(ticketsSold < totalTickets, "All tickets have been sold.");
        
        uint256 ticketId = ticketsSold;
        playerTickets[msg.sender] = ticketId;
        ticketsSold++;
        
        emit TicketBought(msg.sender, ticketId);
    }
    
    function callBingo() public onlyBeforeEnd {
        require(msg.sender == ticketNumbers[winningTicket], "You do not have the winning ticket.");
        gameEnded = true;
        emit BingoCalled(winningTicket);
    }
    
    function claimWinning() public {
        require(gameEnded, "The game has not ended yet.");
        require(msg.sender == ticketNumbers[winningTicket], "You do not have the winning ticket.");
        
        msg.sender.transfer(address(this).balance);
    }
}


//This smart contract allows players to buy tickets for the Bingo game using ether, keeps track of the number of tickets sold and the numbers assigned to each player, and allows players to call Bingo if they have the winning ticket. The onlyBeforeEnd modifier ensures that certain functions can only be executed before the game has ended, and the claimWinning function allows the player with the winning ticket to claim their winnings.



