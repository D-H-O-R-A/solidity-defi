pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC1155/SafeERC1155.sol";

contract MyToken is SafeERC1155 {
    uint256 private _totalSupply;
    mapping (uint256 => uint256) private _tokenBalances;
    mapping (uint256 => mapping (address => uint256)) private _tokenOwners;

    constructor (string memory name, string memory symbol) public {
        _totalSupply = 0;
        setName(name);
        setSymbol(symbol);
    }

    function _mint(address to, uint256[] memory ids) private {
        for (uint256 i = 0; i < ids.length; i++) {
            uint256 id = ids[i];
            _tokenBalances[id]++;
            _tokenOwners[id][to]++;
            _totalSupply++;
            emit TransferSingle(address(0), to, id, _tokenOwners[id][to]);
        }
    }

    function mint(address to, uint256[] memory ids) public {
        _mint(to, ids);
    }

    function _transferFrom(address from, address to, uint256[] memory ids, uint256[] memory values) private {
        for (uint256 i = 0; i < ids.length; i++) {
            uint256 id = ids[i];
            uint256 value = values[i];
            require(_tokenOwners[id][from] >= value);
            _tokenOwners[id][from] -= value;
            _tokenOwners[id][to] += value;
            emit TransferSingle(from, to, id, value);
        }
    }

    function transferFrom(address from, address to, uint256[] memory ids, uint256[] memory values) public {
        _transferFrom(from, to, ids, values);
    }

    function transfer(address to, uint256[] memory ids, uint256[] memory values) public {
        _transferFrom(msg.sender, to, ids, values);
    }

    function balanceOf(address owner, uint256 id) public view returns (uint256) {
        return _tokenOwners[id][owner];
    }

    function totalSupply(uint256 id) public view returns (uint256) {
        return _tokenBalances[id];
    }

    function exists(uint256 id) public view returns (bool) {
        return _tokenBalances[id] > 0;
    }
}



//This implementation extends the SafeERC1155 contract from OpenZeppelin, which provides a secure implementation of the ERC1155 standard. The MyToken contract has functions for minting, transferring, and querying the balance and total supply of multiple token types. It keeps track of the total supply and the ownership of each individual token type through the _tokenBalances and _tokenOwners mappings, respectively.

//As with the ERC721 example, this is just an example and it is recommended to thoroughly test and audit any contract before deployment to the mainnet. Additionally,
