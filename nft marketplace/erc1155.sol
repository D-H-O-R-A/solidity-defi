pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/SafeMath.sol";

contract NFTMarketplace is ERC1155, Ownable {
    using SafeMath for uint256;
    
    string public name = "My NFT Marketplace";
    string public symbol = "NM";
    
    mapping(uint256 => Item) public items;
    mapping(address => uint256) public balances;
    
    struct Item {
        uint256 id;
        address owner;
        uint256 price;
        bool forSale;
    }
    
    constructor() public {
        _mint(msg.sender, 1, 1);
        _mint(msg.sender, 2, 1);
        _mint(msg.sender, 3, 1);
        _mint(msg.sender, 4, 2);
        _mint(msg.sender, 5, 2);
        _mint(msg.sender, 6, 2);
    }
    
    function buyItem(uint256 id, uint256 amount) public {
        require(items[id].forSale, "Item is not for sale");
        require(balances[msg.sender] >= amount, "Insufficient funds");
        require(amount >= items[id].price, "Bid is too low");
        require(ownerOf(id) != msg.sender, "Cannot buy own item");
        super._transferFrom(items[id].owner, msg.sender, id, amount);
        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[items[id].owner] = balances[items[id].owner].add(amount);
        items[id].owner = msg.sender;
        items[id].forSale = false;
        emit ItemBought(id, msg.sender, items[id].owner, amount);
    }
    
    function sellItem(uint256 id, uint256 price) public {
        require(ownerOf(id) == msg.sender, "Only owner can sell item");
        items[id].forSale = true;
        items[id].price = price;
        emit ItemListedForSale(id, msg.sender, items[id].price);
    }
    
    function balanceOf(address owner, uint256 id) public view returns (uint256) {
        return super.balanceOf(owner, id);
    }
    
    function ownerOf(uint256 id) public view returns (address) {
        return super.ownerOf(id);
    }
}

//This contract uses the ERC1155 contract from OpenZeppelin, which is a well-tested and secure implementation of the ERC1155 standard. It also includes the Ownable contract, which gives the contract owner special permissions. Additionally, it uses the SafeMath library for added security when performing arithmetic operations. The contract has functions for buying and selling items, checking the balance of an address, and checking the owner of
