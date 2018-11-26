# Pix

Seller uploads a photo (which is hashed) and a price.
Make the photo a token, the seller can sell that token (photo).

Buyers check what tokens (photo) that are available and buy the token (photo).

Token would have hash and price attribute.
This would be minted everytime the sellers uploads a photo to the Dapp.

Transaction?
Buyer would request to buy a token in exchange for ether.
The buyer would receive a copy of the token to use.
This token would have an attribute that says it is not the original token, but a bought one.

Front End would have display all the photos, which are actually the hashed photo inside each coin.

MintableToken.sol needs to edited so that it only creates tokens when it gets an input for photo and price.
It also needs to have an orignal/duplicate attribute, and it needs to make sure it only creates one per process.
Also, we don't need the wes to token ratio thing. 
When minting the token, we need to know if it's a copy of an original or new creation.

MintableCrowdsale.sol needs to be changed to something else that handles transactions and creation of tokens. 
