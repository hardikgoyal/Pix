pragma solidity ^0.4.24;

// Import the MintableToken contract you just wrote.
import "./MintableToken.sol";

/** Create contract that generates your very own custom ERC20 token with minting capabilities.
 * You'll be "selling" the tokens this contract generates to your classmates using your crowdsale contract.
 * Make sure to inherit functionality from the MintableToken contract.
 * Rename the contract file to the name of your custom token (i.e. EricToken.sol or BuidlDApps.sol or RocketCoin.sol)
 */ 

// Set up your contract. 

contract PixToken is MintableToken {
    // Define 3 public state variables: name, symbol, number of decimals. Make sure decimals are always defined as 18.
    // The token would also have a price and an original boolean value to know who's the owner
    string public constant name = "PixToken";
    string public constant symbol = "PIX";
    uint8 public constant decimals = 18;

    // The token also requires a hash value and an enum that checks what type of photo it is
    bytes32 public constant hash = "";
    enum Originality { Original, Bought, Leased };
    Originality originality;

    constructor(bytes32 _hash) public {
        hash = _hash;
        originality = originality.Original;
    }

    // Change Originality to Bought for tokens that are bought
    function updateOriginalityToBought() private {
        originality = Originality.Bought;
    }

    // Future function that could be used with the smart contract implements leasing features for phtoos
    function updateOriginalityToLeased() private {
        originality = Originality.Leased;
    }

    // get function for Originality
    function getOriginality() public view returns (Originality) {
        return originality;
    }

    // minting tokens with Bought Originality
    function mint(address _to, uint256 _amount) public onlyMinter onlyBeforeMintingFinished returns (bool) {
        // Call mint function which mints inputted amount and assigns it to an account.
        _mint(_to, _amount);
        // Emit the Mint event with appropriate input parameters.    
        emit Mint(_to, _amount);
        // Indicate that the operation was successful. 

        //update originality since it would be for buyers
        updateOriginalityToBought();
        
        return true;
    }
}