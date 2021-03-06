pragma solidity ^0.4.24;

// Import the MintableToken contract you just wrote.
import "./MintableToken.sol";


contract PixToken is MintableToken {
    // Define 3 public state variables: name, symbol, number of decimals. Make sure decimals are always defined as 18.
    // The token would also have a price and an original boolean value to know who's the owner
    string public constant name = "PixToken";
    string public constant symbol = "PIX";
    uint8 public constant decimals = 18;

    // The token also requires a hash value and an enum that checks what type of photo it is
    string public hash;

    constructor(string _hash) public {
        hash = _hash;
    }
}