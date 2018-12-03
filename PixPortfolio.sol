pragma solidity ^0.4.24;

// Import the custom token contract you just wrote.
import "./PixToken.sol";
// Import OpenZeppelin's Ownable contract.
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";

/** This is an assignment to create a smart contract that allows you to run your own token crowdsale.
 *  Your contract will mint your custom token every time a purchase is made by your or your classmates.
 *  We've provided you with the pseudocode and some hints to guide you in the right direction.
 *  Make sure to implement the best practices you learned during the Solidity Walkthrough segment.
 *  Check for errors by compiling often. Ask your classmates for help - we highly encourage student collaboration.
 *  You should be able to deploy your crowdsale contract onto the Rinkeby testnet and buy/sell your classmates' tokens.
 */
 
// Set up your contract.
contract PixPortfolio is Ownable {
    // Attach SafeMath library functions to the uint256 type.
    using SafeMath for uint256;

    // Array to save all the tokens
    PixToken[] public token;
  
    // Owner's wallet
    address public wallet;

    // Mapping of Tokens (aka photo) addresses
    mapping(address => uint256) private prices;

    /** Create event to log token purchase with 4 parameters:
    * 1) Who paid for the tokens (buyer)
    * 2) Who got the tokens (buyer)
    * 3) Number of weis paid for purchase (price)
    * 4) Amount of tokens purchased = 1
    */
    event TokenPurchase(address indexed purchaser, address indexed buyer, uint256 value, uint8 amount);

    /** Create event to log photo upload with parameters:
    * 1) Uploaded photo address
    * 2) Price of the photo
    */
    event UploadPhoto(PixToken _token, uint256 _price);

    /** Create publicly accessible constructor function with 3 parameters:
    * 1) Rate of how many token units a buyer gets per wei
    * 2) Wallet address where funds are collected
    * 3) Address of your custom token being sold
    * Function modifiers are incredibly useful and effective. Make sure to use the right ones for each Solidity function you write.
    */
    constructor(address _wallet) public {
        // Set conditions with require statements to make sure the rate is a positive number and the addresses are non-zero.
        require(_wallet != address(0));

        // Set inputs as defined state variables
        wallet = _wallet;
    }    

    // THIS PORTION IS FOR THE CONTRACT'S EXTERNAL INTERFACE.
    // We suggest skipping down to fill out the internal interface before coming back to complete the external interface.
    
    // Create the fallback function that is called whenever anyone sends funds to this contract.
    // Fallback functions are functions without a name that serve as a default function.
    // Functions dealing with funds have a special modifier.
    function () external payable {
        // no functionality required
    }

    // Create the function used for token (photo)purchase with one parameter for the address receiving the token purchase
    // and the token that's being minted(copied) with a Bought status
    function buyTokens(address _buyer, uint8 _index) public payable {
        require(_index >= 0);
        require(_index < token.length);

        // Define a uint256 variable that is equal to the number of wei sent with the message.
        uint256 weiAmount = msg.value;

        // Check if the buyer is sending the correct price amount
        require(weiAmount != 0);
        require(weiAmount == prices[_index]);

        // Call function that validates an incoming purchase with two parameters, receiver and number of wei sent.
        _preValidatePurchase(_buyer, weiAmount);

        // Mint one token 
        uint8 tokenAmmount = 1;

        // Call function that processes a purchase.
        _processPurchase(_buyer, tokenAmmount, _index);

        // Raise the event associated with a token purchase.
        emit TokenPurchase(msg.sender, _buyer, weiAmount, tokenAmmount);
    
        // Call function that stores ETH from purchases into a wallet address.
        _forwardFunds();
    }

    // Upload photo address to map and array for storing and tracking purposes
    // called by the owner of the contract through the front end website
    function uploadPhoto(PixToken _tokenAddress, uint256 _price) onlyOwner external {
        //add address to array and map with price
        require(_price != 0);
        token.push(_tokenAddress);
        prices[_tokenAddress] = _price;

        emit UploadPhoto(_tokenAddress, _price);
    }
    
    function displayPhotos() external view returns(PixToken[]) {
        return token;
    }
    
    // function setPrice(uint256 _index, uint256 _price) external {
        
    // }

    // THIS PORTION IS FOR THE CONTRACT'S INTERNAL INTERFACE.
    // Remember, the following functions are for the contract's internal interface.
    
    // Create function that validates an incoming purchase with two parameters: buyer's address and value of wei.
    function _preValidatePurchase(address _buyer, uint256 _weiAmount) pure internal {
        // Set conditions to make sure the buyer's address and the value of wei involved in purchase are non-zero.
        require(_buyer != address(0));
        require(_weiAmount != 0);
    }

    // Create function that delivers the purchased tokens with two parameters: buyer's address and number of tokens.
    function _deliverTokens(address _buyer, uint8 _tokenAmount, uint8 _index) internal {
        // Set condition that requires contract to mint your custom token with the mint method inherited from your MintableToken contract.
        require(PixToken(token[_index]).mint(_buyer, _tokenAmount));
    }

    // Create function that executes the deliver function when a purchase has been processed with two parameters: buyer's address and number of tokens.
    function _processPurchase(address _buyer, uint8 _tokenAmount, uint8 _index) internal {
        _deliverTokens(_buyer, _tokenAmount, _index);
    }

    // Create function to store ETH from purchases into a wallet address.
    function _forwardFunds() internal {
        wallet.transfer(msg.value);
    }
}