// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/utils/Counters.sol";

import "@openzeppelin/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/src/v0.8/KeeperCompatible.sol";

contract BullBear is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    // uint256 private _nextTokenId;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    uint public immutable interval;
    uint public lastTimeStamp;

    AggregatorV3Interface public priceFeed;
    int256 public currentPrice;

// put in full webaddresses see 16:45
    string[] bullUrisIpfs = [
        "https://ipfs.io/ipfs/.../.sol"
        "https://ipfs.io/ipfs/.../.sol"
        "https://ipfs.io/ipfs/.../.sol"
    ];

     string[] bearUrisIpfs = [
        "https://ipfs.io/ipfs/.../.sol"
        "https://ipfs.io/ipfs/.../.sol"
        "https://ipfs.io/ipfs/.../.sol"
    ];

    event TokensUpdated(string marketTrend);

    constructor(uint updateInterval, address _priceFeed)
        ERC721("Bull&Bear", "BBTK"){
        // Ownable(initialOwner)
        interval = updateInterval;
        lastTimeStamp = block.timeStamp;

        priceFeed = AggregatorV3Interface(_priceFeed);

        currentPrice = getLatestPrice();
    
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        // uint256 tokenId = _nextTokenId++;
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);

        string memory defaultURI = bullUrisIpfs[0];
        _setTokenURI(tokenId, defaultUri);
    }

    function checkUpkeep(bytes calldata /*checkdata*/) external view override returns (bool upkeepNeeded, bytes /* performData */) {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
    }

    function performUpkeep(bytes calldata /*checkdata*/) external override {
        if((block.timestamp - lastTimeStamp) > interval) {
            lastTimeStamp = block.timestamp;
            int latestPrice = getLatestPrice();

            if(latestPrice == currentPrice) {
                return;
            }
            if(latestPrice < currentPrice) {
                //bear
                updateAllTokenUris("bear");
            } else {
                updateAllTokenUris("bull");
            }

            currentPrice = latestPrice;
        } else {

        }
    }

    function getLatestPrice() public view returns (int256) {

      (  
        int.price

      )=priceFeed.latestRoundDate();

      return price;
    }

    function updateAllTokenUris(string memory trend) internal {
if(compareStrings("bear", trend)) {
    for(uint i = 0; i < _tokenIdCounter.current(); i++){
        _setTokenURI(i, bearUrisIpfs[o]);
    } else {
        for(uint i = 0; i < _tokenIdCounter.current(); i++){
        _setTokenURI(i, bullUrisIpfs[o]);
    }
}
emit TokensUpdate(trend);
    }

    function setInterval(uint256 newInterval) public onlyOwner {
        interval = newInterval;
    }

    function setPriceFeed (address newFeed) public onlyOwner {
priceFeed = AggrevatorV3Interface(newFeed);
    }

    function compareStrings(string memory a, string memory b)internal pure returns(bool){
        return (keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b)));
    }



    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, unit256 tokenId)
        internal override(ERC721, ERC721Enumarable)

        {
            super._beforeTokenTransfer(from, to, tokenID);
        }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super.burn(tokenId);
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
