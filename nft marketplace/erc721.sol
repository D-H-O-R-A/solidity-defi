pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";

contract NFTMarketplace is ERC721, Ownable {
    using SafeMath for uint256;

    mapping(uint256 => address) public tokenOwner;
    mapping(uint256 => uint256) public tokenIdToPrice;

    event NewTokenListing(
        uint256 indexed tokenId,
        uint256 price
    );

    event TokenSold(
        uint256 indexed tokenId,
        address indexed buyer,
        uint256 price
    );

    constructor() ERC721("NFTMarketplace", "NFTM") public {}

    function listTokenForSale(uint256 tokenId, uint256 price) public onlyOwner(tokenId) {
        require(price > 0, "Price must be greater than zero.");
        require(tokenIdToPrice[tokenId] == 0, "Token is already listed for sale.");

        tokenIdToPrice[tokenId] = price;
        emit NewTokenListing(tokenId, price);
    }

    function buyToken(uint256 tokenId) public payable {
        require(tokenIdToPrice[tokenId] > 0, "Token is not for sale.");
        require(msg.value >= tokenIdToPrice[tokenId], "Offered price is lower than the asking price.");

        address seller = tokenOwner[tokenId];
        uint256 price = tokenIdToPrice[tokenId];

        _transfer(seller, msg.sender, tokenId);

        seller.transfer(price);
        tokenIdToPrice[tokenId] = 0;

        emit TokenSold(tokenId, msg.sender, price);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override {
        require(isApprovedOrOwner(from, msg.sender), "Not authorized to transfer.");
        require(from != address(0), "From address is zero.");
        require(to != address(0), "To address is zero.");

        _transfer(from, to, tokenId);
    }

    function isApprovedOrOwner(address spender, address owner) internal view returns (bool) {
        return spender == owner || getApproved(tokenId) == spender;
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        require(tokenOwner[tokenId] == from, "From address is not the owner.");
        require(to != address(0), "To address is zero.");

        tokenOwner[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }
}


//This contract implements the ERC721 standard and also includes additional functionality for listing tokens for sale, buying tokens, and securely transferring tokens. The contract also



