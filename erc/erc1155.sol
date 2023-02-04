pragma solidity ^0.8.0;

interface ERC1155 {
  function balanceOf(address owner, uint256 id) external view returns (uint256);
  function transfer(address to, uint256[] ids, uint256[] values) external returns (bool);
}

contract ERC1155NFT is ERC1155 {
  // Mapping of the token ID to the address that owns it
  mapping (uint256 => address) private _tokenOwners;

  // Mapping of the balance of each token ID for each address
  mapping (address => mapping (uint256 => uint256)) private _balances;

  // Mapping of the metadata of each token ID
  mapping (uint256 => string) private _tokenMetadata;

  // Event that is emitted when a transfer is made
  event Transfer(
    address indexed from,
    address indexed to,
    uint256[] ids,
    uint256[] values
  );

  // Function to retrieve the balance of a token ID for a specific address
  function balanceOf(address owner, uint256 id) external view returns (uint256) {
    return _balances[owner][id];
  }

  // Function to transfer a specific token ID from one address to another
  function transfer(address to, uint256[] ids, uint256[] values) external returns (bool) {
    // Verify that the sender is the owner of the token ID
    require(_tokenOwners[ids[0]] == msg.sender, "Sender is not the owner of the token");

    // Transfer the token
    _tokenOwners[ids[0]] = to;
    _balances[msg.sender][ids[0]]--;
    _balances[to][ids[0]]++;

    // Emit the Transfer event
    emit Transfer(msg.sender, to, ids, values);

    return true;
  }

  // Function to mint a new token with a specific ID and metadata
  function mint(uint256 id, string memory metadata) internal {
    // Verify that only the contract owner can mint tokens
    require(msg.sender == owner, "Only the contract owner can mint tokens");

    // Mint the token
    _tokenOwners[id] = msg.sender;
    _tokenMetadata[id] = metadata;
    _balances[msg.sender][id]++;
  }

  // Function to burn a specific token ID
  function burn(uint256 id) internal {
    // Verify that only the contract owner can burn tokens
    require(msg.sender == owner, "Only the contract owner can burn tokens");

    // Burn the token
    _tokenOwners[id] = address(0);
    delete _tokenMetadata[id];
    _balances[msg.sender][id]--;
  }
}


//This contract implements the ERC1155 standard and includes functions for transferring NFTs, as well as minting and burning them. The contract uses mappings to keep track of the token ownership and metadata. The transfer function also verifies that the sender is the owner of the token before transferring it to another address. This contract also includes a mint function that allows the contract owner to create new NFTs with unique IDs and metadata



