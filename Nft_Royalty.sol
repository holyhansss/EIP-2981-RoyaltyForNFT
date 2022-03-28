// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";

contract MyToken is ERC721, ERC721Enumerable, Ownable {
    uint256 royaltyFeeInBips;
    address royaltyReceiver;

    string public contractURI;

    constructor(uint _royaltyFeeInBips, string memory _contractURI) ERC721("RoyaltyTestToken", "RTK") {
        royaltyFeeInBips = _royaltyFeeInBips;
        contractURI = _contractURI;
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return interfaceId == 0x2a55205a || super.supportsInterface(interfaceId);
    }

    function royaltyInfo(
        uint256 _tokenId,
        uint256 _salePrice
    ) external view returns(
    address receiver,
    uint256 royaltyAmount
    ) {
        return (royaltyReceiver, calculateRoyalty(_salePrice));
    }

    function calculateRoyalty(uint256 _salePrice) view public returns (uint256) {
        return (_salePrice / 10000) * royaltyFeeInBips;
    }

    function setRoyaltyInfo(address _receiver, uint256 _royaltyFeeInBips) public onlyOwner {
        royaltyReceiver = _receiver;
        royaltyFeeInBips = _royaltyFeeInBips;
    }

    function setContractURI(string calldata _contractURI) public onlyOwner{
        contractURI = _contractURI;
    } 


}
