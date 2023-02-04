pragma solidity ^0.8.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

contract DEXFarmsWithFees {
    using SafeMath for uint256;
    
    struct Farm {
        address owner;
        uint256 deposit;
        uint256 withdrawTime;
        uint256 fee;
    }
    
    ERC20 public token;
    uint256 public totalSupply;
    mapping(address => uint256) public balances;
    Farm[] public farms;
    uint256 public feePercentage;
    
    constructor(address _token, uint256 _feePercentage) public {
        token = ERC20(_token);
        totalSupply = token.totalSupply();
        feePercentage = _feePercentage;
    }
    
    function depositToFarm(uint256 amount) public payable {
        uint256 fee = (amount.mul(feePercentage)) / 100;
        require(token.transferFrom(msg.sender, address(this), amount), "Token transfer failed");
        farms.push(Farm({
            owner: msg.sender,
            deposit: amount,
            withdrawTime: now + 1 week,
            fee: fee
        }));
        emit FarmDeposited(msg.sender, amount);
    }
    
    function withdrawFromFarm(uint256 index) public {
        uint256 fee = (farms[index].deposit.mul(feePercentage)) / 100;
        require(farms[index].owner == msg.sender, "Only owner can withdraw");
        require(now >= farms[index].withdrawTime, "Withdrawal time has not yet arrived");
        require(token.transfer(msg.sender, farms[index].deposit.sub(fee)), "Token transfer failed");
        farms[index].owner = address(0);
        farms[index].deposit = 0;
        farms[index].withdrawTime = 0;
        farms[index].fee = 0;
        emit FarmWithdrawn(msg.sender, farms[index].deposit);
    }
}

//This contract allows users to deposit ERC20 tokens into a farm, where they will be held for a set period of time before they can be withdrawn. The deposit operation takes a fee percentage, which is subtracted from the deposit when it is withdrawn. The deposit and withdrawal operations are protected by various checks, such as ensuring that only the deposit owner can withdraw and that the withdrawal time has arrived.

//Note that this is just an example, and it is important to thoroughly test and audit any smart contracts before deploying them on a public blockchain.
