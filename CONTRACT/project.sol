// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RandomizedNFTGenerator {

    string public name = "RandomizedNFT";
    string public symbol = "RNFT";

    uint256 public mintPrice;
    uint256 public totalSupply;
    address public owner;

    // Mapping to store owner of each tokenId
    mapping(uint256 => address) public tokenOwners;

    // Mapping to store token URI for each tokenId
    mapping(uint256 => string) public tokenURIs;

    // Mapping to track if a token has been minted
    mapping(uint256 => bool) public mintedTokens;

    event NFTMinted(address indexed owner, uint256 indexed tokenId, string tokenURI);
    event MintPriceUpdated(uint256 newPrice);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier hasMintPrice() {
        require(msg.value >= mintPrice, "Insufficient funds to mint NFT");
        _;
    }

    constructor(uint256 _mintPrice) {
        owner = msg.sender;
        mintPrice = _mintPrice;
        totalSupply = 0;
    }

    // Function to mint a new NFT
    function mintNFT(address recipient, string memory _tokenURI) external payable hasMintPrice returns (uint256) {
        totalSupply++;
        uint256 newItemId = totalSupply;

        // Ensure that the tokenId has not been minted yet
        require(!mintedTokens[newItemId], "Token already minted");

        tokenOwners[newItemId] = recipient;
        tokenURIs[newItemId] = _tokenURI;
        mintedTokens[newItemId] = true;

        emit NFTMinted(recipient, newItemId, _tokenURI);
        return newItemId;
    }

    // Function to update minting price
    function updateMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
        emit MintPriceUpdated(newPrice);
    }

    // Function to withdraw funds from the contract
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    // Function to get the URI for a specific token
    function getTokenURI(uint256 tokenId) external view returns (string memory) {
        return tokenURIs[tokenId];
    }

    // Function to get the owner of a specific token
    function getTokenOwner(uint256 tokenId) external view returns (address) {
        return tokenOwners[tokenId];
    }
}

