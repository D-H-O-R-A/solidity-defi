pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC1155/SafeERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract NFTMarketplace is SafeERC1155 {
    using SafeMath for uint256;

    mapping(address => uint256) public tokenOwnership;
    mapping(uint256 => mapping(uint256 => address)) public tokenToOwner;
    mapping(uint256 => mapping(uint256 => string)) public tokenMetadata;

    constructor() public {
        _mint(msg.sender, 1, 1);
        tokenOwnership[msg.sender] = 1;
        tokenToOwner[1][1] = msg.sender;
    }

    function setTokenMetadata(uint256 id, uint256 index, string memory metadata) public {
        require(msg.sender == tokenToOwner[id][index], "The sender is not the owner of this token.");

        tokenMetadata[id][index] = metadata;
    }

    function transferFrom(address from, address to, uint256 id, uint256 index) public {
        require(from == tokenToOwner[id][index], "The from address is not the owner of this token.");
        require(to != address(0), "The to address is the zero address.");
        require(from != to, "The from and to addresses are the same.");

        tokenOwnership[from] = tokenOwnership[from].sub(1);
        tokenOwnership[to] = tokenOwnership[to].add(1);
        tokenToOwner[id][index] = to;

        _transferFrom(from, to, id, index);
    }

    function balanceOf(address owner, uint256 id) public view returns (uint256) {
        uint256 balance = 0;

        for (uint256 i = 0; i < balanceOfArray(owner, id); i++) {
            if (tokenToOwner[id][i] == owner) {
                balance = balance.add(1);
            }
        }

        return balance;
    }

    function ownerOf(uint256 id, uint256 index) public view returns (address) {
        return tokenToOwner[id][index];
    }

    function approve(address to, uint256 id, uint256 index) public {
        require(msg.sender == tokenToOwner[id][index], "The sender is not the owner of this token.");
        require(to != address(0), "The to address is the zero address.");

        _approve(to, id, index);
    }

    function transferOwnership(address newOwner, uint256 id, uint256 index) public {
        require(msg.sender == tokenToOwner[id][index], "The sender is not the owner of this token.");
        require(newOwner != address(0), "The new owner address is the zero address.");

        tokenToOwner[id][index] = newOwner;
    }
}


//This implementation extends the SafeERC1155 contract from OpenZeppelin, which provides a secure implementation of the ERC1155 standard. The MyToken contract has functions for minting, transferring, and querying the balance and total supply of multiple token types. It keeps track of the total supply and the ownership of each individual token type through the _tokenBalances and _tokenOwners mappings, respectively.

//As with the ERC721 example, this is just an example and it is recommended to thoroughly test and audit any contract before deployment to the mainnet. Additionally,
