pragma solidity ^0.8.20;

contract Coin {
    address public minter;
    mapping(address => uint) public balances;

    constructor() {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) external {
        require(msg.sender == minter, "Only owner can mint!");
        balances[receiver] = balances[receiver] + amount;
    }

    event Sent(address from, address to, uint amount);

    function send(address reciever, uint amount) external payable {
        require(
            balances[msg.sender] >= amount,
            "Insufficient amount of tokens"
        );
        balances[msg.sender] = balances[msg.sender] - amount;
        balances[reciever] = balances[reciever] + amount;
        emit Sent(msg.sender, reciever, amount);
    }

    function burn(address reciever, uint amount) external payable {
        require(msg.sender == minter, "Only owner can mint!");
        require(balances[reciever] >= amount, "Insufficient amount of tokens");
        balances[reciever] = balances[reciever] - amount;
    }
}
