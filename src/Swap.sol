// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract Swap {
    IERC20 public ethToken;
    IERC20 public linkToken;
    IERC20 public daiToken;

    AggregatorV3Interface internal ethUsdPriceFeed;
    AggregatorV3Interface internal linkUsdPriceFeed;
    AggregatorV3Interface internal daiUsdPriceFeed;

    constructor() {
        ethToken = IERC20(0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9); // Address of Ether (ETH)
        linkToken = IERC20(0x779877A7B0D9E8603169DdbD7836e478b4624789); // Address of Chainlink token (LINK)
        daiToken = IERC20(0x3e622317f8C93f7328350cF0B56d9eD4C620C5d6); // Address of Dai stablecoin (DAI)

        ethUsdPriceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        ); // Address of ETH/USD price feed
        linkUsdPriceFeed = AggregatorV3Interface(
            0xc59E3633BAAC79493d908e63626716e204A45EdF
        ); // Address of LINK/USD price feed
        daiUsdPriceFeed = AggregatorV3Interface(
            0x14866185B1962B63C3Ea9E03Bc1da838bab34C19
        ); // Address of DAI/USD price feed
    }

    function ethToLink(uint256 ethAmount) external {
        uint256 ethUsdPrice = getEthUsdPrice();
        uint256 linkUsdPrice = getLinkUsdPrice();
        uint256 linkAmount = (ethAmount * ethUsdPrice) / linkUsdPrice;
        require(
            linkToken.transferFrom(msg.sender, address(this), linkAmount),
            "Failed to transfer LINK"
        );
        require(
            ethToken.transfer(msg.sender, ethAmount),
            "Failed to transfer ETH"
        );
    }

    function linkToEth(uint256 linkAmount) external {
        uint256 ethUsdPrice = getEthUsdPrice();
        uint256 linkUsdPrice = getLinkUsdPrice();
        uint256 ethAmount = (linkAmount * linkUsdPrice) / ethUsdPrice;
        require(
            ethToken.transferFrom(msg.sender, address(this), ethAmount),
            "Failed to transfer ETH"
        );
        require(
            linkToken.transfer(msg.sender, linkAmount),
            "Failed to transfer LINK"
        );
    }

    function ethToDai(uint256 ethAmount) external {
        uint256 ethUsdPrice = getEthUsdPrice();
        uint256 daiUsdPrice = getDaiUsdPrice();
        uint256 daiAmount = (ethAmount * ethUsdPrice) / daiUsdPrice;
        require(
            daiToken.transferFrom(msg.sender, address(this), daiAmount),
            "Failed to transfer DAI"
        );
        require(
            ethToken.transfer(msg.sender, ethAmount),
            "Failed to transfer ETH"
        );
    }

    function daiToEth(uint256 daiAmount) external {
        uint256 ethUsdPrice = getEthUsdPrice();
        uint256 daiUsdPrice = getDaiUsdPrice();
        uint256 ethAmount = (daiAmount * daiUsdPrice) / ethUsdPrice;
        require(
            ethToken.transferFrom(msg.sender, address(this), ethAmount),
            "Failed to transfer ETH"
        );
        require(
            daiToken.transfer(msg.sender, daiAmount),
            "Failed to transfer DAI"
        );
    }

    function linkToDai(uint256 linkAmount) external {
        uint256 linkUsdPrice = getLinkUsdPrice();
        uint256 daiUsdPrice = getDaiUsdPrice();
        uint256 daiAmount = (linkAmount * linkUsdPrice) / daiUsdPrice;
        require(
            daiToken.transferFrom(msg.sender, address(this), daiAmount),
            "Failed to transfer DAI"
        );
        require(
            linkToken.transfer(msg.sender, linkAmount),
            "Failed to transfer LINK"
        );
    }

    function daiToLink(uint256 daiAmount) external {
        uint256 linkUsdPrice = getLinkUsdPrice();
        uint256 daiUsdPrice = getDaiUsdPrice();
        uint256 linkAmount = (daiAmount * daiUsdPrice) / linkUsdPrice;
        require(
            linkToken.transferFrom(msg.sender, address(this), linkAmount),
            "Failed to transfer LINK"
        );
        require(
            daiToken.transfer(msg.sender, daiAmount),
            "Failed to transfer DAI"
        );
    }

    function getEthUsdPrice() public view returns (uint256) {
        (, int256 price, , , ) = ethUsdPriceFeed.latestRoundData();
        return uint256(price);
    }

    function getLinkUsdPrice() public view returns (uint256) {
        (, int256 price, , , ) = linkUsdPriceFeed.latestRoundData();
        return uint256(price);
    }

    function getDaiUsdPrice() public view returns (uint256) {
        (, int256 price, , , ) = daiUsdPriceFeed.latestRoundData();
        return uint256(price);
    }
}
