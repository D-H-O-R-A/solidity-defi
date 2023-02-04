pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

contract MyToken is SafeERC20 {
    uint256 private _totalSupply;

    constructor (string memory name, string memory symbol, uint256 initialSupply) public {
        _totalSupply = initialSupply;
        setName(name);
        setSymbol(symbol);
        setTotalSupply(initialSupply);
        addBalance(msg.sender, initialSupply);
    }

    function transfer(address to, uint256 value) public {
        require(to != address(0));
        require(value <= balanceOf(msg.sender));
        subBalance(msg.sender, value);
        addBalance(to, value);
        emit Transfer(msg.sender, to, value);
    }

    function approve(address spender, uint256 value) public {
        require(spender != address(0));
        setApprovalForAll(spender, true);
        emit Approval(msg.sender, spender, value);
    }

    function transferFrom(address from, address to, uint256 value) public {
        require(to != address(0));
        require(value <= balanceOf(from));
        require(value <= allowance(from, msg.sender));
        subBalance(from, value);
        addBalance(to, value);
        subApproval(from, msg.sender, value);
        emit Transfer(from, to, value);
    }

    function balanceOf(address account) public view returns (uint256) {
        return getBalance(account);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
}


