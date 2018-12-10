pragma solidity ^0.4.24;

// Import the custom token contract you just wrote.
import "./PixToken.sol";
// Import OpenZeppelin's Ownable contract.
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";
 
// Set up your contract.
contract PixPortfolio is Ownable {
    // Attach SafeMath library functions to the uint256 type.
    using SafeMath for uint256;

    // Array to save all the tokens
    PixToken[] public photoTokens;
  
    // Owner's wallet
    address public ownerWallet;

    // Mapping of Tokens (aka photo) addresses
    mapping(address => uint256) private photoPrices;

    /** Create event to log token purchase with 4 parameters:
    * 1) Who paid for the tokens (buyer)
    * 2) Who got the tokens (buyer)
    * 3) Number of weis paid for purchase (price)
    * 4) Amount of tokens purchased = 1
    */
    event photoPurchase(address indexed purchaser, address indexed buyer, uint256 value, uint8 amount);

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
        ownerWallet = _wallet;
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
    function buyPhotoToken(address _buyer, uint256 _index) public payable {
        require(_index >= 0);
        require(_index < photoTokens.length);

        // Define a uint256 variable that is equal to the number of wei sent with the message.
        uint256 weiAmount = msg.value;

        // Check if the buyer is sending the correct price amount
        require(weiAmount == photoPrices[photoTokens[_index]]);

        // Call function that validates an incoming purchase with two parameters, receiver and number of wei sent.
        _preValidatePurchase(_buyer, weiAmount);

        // Mint one token 
        uint8 tokenAmmount = 1;

        // Call function that processes a purchase.
        _processPurchase(_buyer, tokenAmmount, _index);

        // Raise the event associated with a token purchase.
        emit photoPurchase(msg.sender, _buyer, weiAmount, tokenAmmount);
    
        // Call function that stores ETH from purchases into a wallet address.
        _forwardFunds();
    }

    // Upload photo address to map and array for storing and tracking purposes
    // called by the owner of the contract through the front end website
    function uploadPhoto(PixToken _photoTokenAddress, uint256 _photoPrice) onlyOwner external {
        //add address to array and map with price
        require(_photoPrice != 0);
        photoTokens.push(_photoTokenAddress);
        photoPrices[_photoTokenAddress] = _photoPrice;

        emit UploadPhoto(_photoTokenAddress, _photoPrice);
    }
    
    function displayPhotos() external view returns(PixToken[]) {
        return photoTokens;
    }
    
    function setPrice(uint256 _index, uint256 _price) external {
        photoPrices[photoTokens[_index]] = _price;

    }

    // THIS PORTION IS FOR THE CONTRACT'S INTERNAL INTERFACE.
    // Remember, the following functions are for the contract's internal interface.
    
    // Create function that validates an incoming purchase with two parameters: buyer's address and value of wei.
    function _preValidatePurchase(address _buyer, uint256 _weiAmount) pure internal {
        // Set conditions to make sure the buyer's address and the value of wei involved in purchase are non-zero.
        require(_buyer != address(0));
        require(_weiAmount != 0);
    }

    // Create function that delivers the purchased tokens with two parameters: buyer's address and number of tokens.
    function _deliverTokens(address _buyer, uint8 _tokenAmount, uint256 _index) internal {
        // Set condition that requires contract to mint your custom token with the mint method inherited from your MintableToken contract.
        require(PixToken(photoTokens[_index]).mint(_buyer, _tokenAmount));
    }

    // Create function that executes the deliver function when a purchase has been processed with two parameters: buyer's address and number of tokens.
    function _processPurchase(address _buyer, uint8 _tokenAmount, uint256 _index) internal {
        _deliverTokens(_buyer, _tokenAmount, _index);
    }

    // Create function to store ETH from purchases into a wallet address.
    function _forwardFunds() internal {
        ownerWallet.transfer(msg.value);
    }
}