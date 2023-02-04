pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/SafeERC721.sol";

contract MyToken is SafeERC721 {
    constructor() public {
        _mint(msg.sender, 1);
        _mint(msg.sender, 2);
        _mint(msg.sender, 3);
    }

    function mint(address to, uint256 id) public onlyOwner {
        require(to != address(0), "Invalid address");
        _mint(to, id);
    }

    function transferFrom(address from, address to, uint256 id) public {
        require(_checkTransferFrom(from, to, id), "Transfer failed");
        _transferFrom(from, to, id);
    }
}


//In this example, the ERC721 token is derived from the SafeERC721 contract from the OpenZeppelin library, which provides added security features such as protection against reentrancy and protection against overflow and underflow attacks. The mint function can only be called by the owner of the contract and adds a new token with the specified ID to the to address. The transferFrom function includes a check to ensure that the transfer is valid before executing it. In this example, three tokens with the IDs 1, 2, and 3 are initially minted to the msg.sender.
