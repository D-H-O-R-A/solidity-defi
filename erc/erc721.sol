pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/SafeERC721.sol";

contract MyToken is SafeERC721 {
    uint256 private _totalSupply;
    mapping (uint256 => address) private _tokenOwners;

    constructor (string memory name, string memory symbol) public {
        _totalSupply = 0;
        _tokenOwners[0] = address(0);
        setName(name);
        setSymbol(symbol);
    }

    function _mint(address to, uint256 tokenId) private {
        _totalSupply++;
        _tokenOwners[tokenId] = to;
        emit Transfer(address(0), to, tokenId);
    }

    function mint(address to) public {
        _mint(to, _totalSupply);
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(from == _tokenOwners[tokenId]);
        _tokenOwners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }

    function transfer(address to, uint256 tokenId) public {
        require(msg.sender == _tokenOwners[tokenId]);
        _tokenOwners[tokenId] = to;
        emit Transfer(msg.sender, to, tokenId);
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        return _tokenOwners[tokenId];
    }

    function balanceOf(address owner) public view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < _totalSupply; i++) {
            if (_tokenOwners[i] == owner) {
                count++;
            }
        }
        return count;
    }

    function exists(uint256 tokenId) public view returns (bool) {
        return _tokenOwners[tokenId] != address(0);
    }
}

//This implementation extends the SafeERC721 contract from OpenZeppelin, which provides a secure implementation of the ERC721 standard. The MyToken contract has functions for minting, transferring, and querying ownership of tokens. It also keeps track of the total supply and the ownership of each individual token through the _tokenOwners mapping.
//This is just an example, and it is recommended to thoroughly test and audit any contract before deployment to the mainnet. Additionally, security risks and vulnerabilities can change over time, so it's important to stay up-to-date with best practices and new developments in the Ethereum ecosystem.
