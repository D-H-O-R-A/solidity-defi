pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace is ERC721 {
    mapping(address => uint256) public tokenIdToPrice;

    event OfferCreated(address indexed owner, uint256 tokenId, uint256 price);
    event OfferAccepted(address indexed buyer, uint256 tokenId, uint256 price);
    event OfferCancelled(address indexed owner, uint256 tokenId, uint256 price);

    function createOffer(uint256 tokenId, uint256 price) public onlyOwnerOf(tokenId) {
        require(tokenIdToPrice[tokenId] == 0, "Offer already exists for this token");
        tokenIdToPrice[tokenId] = price;
        emit OfferCreated(msg.sender, tokenId, price);
    }

    function acceptOffer(uint256 tokenId) public payable {
        require(tokenIdToPrice[tokenId] != 0, "Offer does not exist for this token");
        require(msg.value >= tokenIdToPrice[tokenId], "Offer price not met");
        address owner = ownerOf(tokenId);
        require(owner != address(0), "Token ownership not found");
        tokenIdToPrice[tokenId] = 0;
        emit OfferAccepted(msg.sender, tokenId, tokenIdToPrice[tokenId]);
        owner.transfer(tokenIdToPrice[tokenId]);
    }

    function cancelOffer(uint256 tokenId) public onlyOwnerOf(tokenId) {
        require(tokenIdToPrice[tokenId] != 0, "Offer does not exist for this token");
        uint256 price = tokenIdToPrice[tokenId];
        tokenIdToPrice[tokenId] = 0;
        emit OfferCancelled(msg.sender, tokenId, price);
    }
}

//This code implements a simple NFT marketplace that allows owners to create offers for their NFTs, buyers to accept offers, and owners to cancel offers. The contract uses the ERC721 contract from OpenZeppelin as a base, which implements the ERC721 standard. The createOffer function allows an NFT owner to create an offer for their NFT at a certain price. The acceptOffer function allows a buyer to accept an offer by sending the required funds to the contract. The cancelOffer function allows an NFT owner to cancel an offer. The contract emits events for each offer creation, acceptance, and cancellation. This code is a sample and may not cover all the potential security considerations for an NFT marketplace contract.
