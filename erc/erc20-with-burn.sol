pragma solidity ^0.8.0;

contract ERC20Token {
    string public constant name = "Token";
    string public constant symbol = "TKN";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed burner, uint256 value);

    constructor(uint256 initialSupply) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balances[msg.sender] = totalSupply;
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(balances[msg.sender] >= value, "Not enough balance");
        require(balances[to] + value >= balances[to], "Overflow");
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(balances[from] >= value, "Not enough balance");
        require(allowed[from][msg.sender] >= value, "Not enough allowance");
        require(balances[to] + value >= balances[to], "Overflow");
        balances[from] -= value;
        allowed[from][msg.sender] -= value;
        balances[to] += value;
        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowed[msg.sender][spender] = value;
        return true;
    }

    function burn(uint256 value) public returns (bool) {
        require(balances[msg.sender] >= value, "Not enough balance");
        balances[msg.sender] -= value;
        totalSupply -= value;
        emit Burn(msg.sender, value);
        return true;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return allowed[owner][spender];
    }
}


// This code implements all the necessary functions for an ERC20 token, including transfer, transferFrom, approve, and burn. The transfer and transferFrom functions have checks for sufficient balance and overflow protection. The approve function allows an owner to approve a spender to transfer their tokens. The burn function allows a user to burn their own tokens and reduce the total supply. Note that this code is only a sample and may not cover all the potential security considerations for an ERC20 token contract.
