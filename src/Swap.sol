// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract Swap {
    IERC20 dai;
    IERC20 link;
    IERC20 weth;

    AggregatorV3Interface eth_usd;
    AggregatorV3Interface link_usd;
    AggregatorV3Interface dai_usd;

    constructor() {
        weth = IERC20(0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9); // Address of Ether (ETH)
        link = IERC20(0x779877A7B0D9E8603169DdbD7836e478b4624789); // Address of Chainlink token (LINK)
        dai = IERC20(0x3e622317f8C93f7328350cF0B56d9eD4C620C5d6); // Address of Dai stablecoin (DAI)

        eth_usd = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        ); // Address of ETH/USD price feed
        link_usd = AggregatorV3Interface(
            0xc59E3633BAAC79493d908e63626716e204A45EdF
        ); // Address of LINK/USD price feed
        dai_usd = AggregatorV3Interface(
            0x14866185B1962B63C3Ea9E03Bc1da838bab34C19
        ); // Address of DAI/USD price feed
    }

    event SwapSuccessful(
        address indexed sender,
        uint indexed amountA,
        uint indexed amountB
    );

    function swapEthDai(uint256 _amountA) external {
        require(msg.sender != address(0), "address zero detected");
        require(_amountA > 0, "Can't exchange zero amount");
        require(weth.balanceOf(msg.sender) >= _amountA, "Insufficient Balance");
        uint _amountB = uint(getDerivedPrice(eth_usd, dai_usd, 18));
        require(dai.balanceOf(address(this)) >= _amountB, "Not enough tokenB");
        weth.transferFrom(msg.sender, address(this), _amountA);
        dai.transfer(msg.sender, _amountB);
        emit SwapSuccessful(msg.sender, _amountA, _amountB);
    }

    function swapEthLink(uint256 _amountA) external {
        require(msg.sender != address(0), "address zero detected");
        require(_amountA > 0, "Can't exchange zero amount");
        require(weth.balanceOf(msg.sender) >= _amountA, "Insufficient Balance");
        uint _amountB = uint(getDerivedPrice(eth_usd, link_usd, 18));
        require(link.balanceOf(address(this)) >= _amountB, "Not enough tokenB");
        weth.transferFrom(msg.sender, address(this), _amountA);
        link.transfer(msg.sender, _amountB);
        emit SwapSuccessful(msg.sender, _amountA, _amountB);
    }

    function swapLinkDai(uint256 _amountA) external {
        require(msg.sender != address(0), "address zero detected");
        require(_amountA > 0, "Can't exchange zero amount");
        require(link.balanceOf(msg.sender) >= _amountA, "Insufficient Balance");
        uint _amountB = uint(getDerivedPrice(link_usd, dai_usd, 18));
        require(dai.balanceOf(address(this)) >= _amountB, "Not enough tokenB");
        link.transferFrom(msg.sender, address(this), _amountA);
        dai.transfer(msg.sender, _amountB);
        emit SwapSuccessful(msg.sender, _amountA, _amountB);
    }

    function swapLinkEth(uint256 _amountA) external {
        require(msg.sender != address(0), "address zero detected");
        require(_amountA > 0, "Can't exchange zero amount");
        require(link.balanceOf(msg.sender) >= _amountA, "Insufficient Balance");
        uint _amountB = uint(getDerivedPrice(link_usd, eth_usd, 18));
        require(weth.balanceOf(address(this)) >= _amountB, "Not enough tokenB");
        link.transferFrom(msg.sender, address(this), _amountA);
        weth.transfer(msg.sender, _amountB);
        emit SwapSuccessful(msg.sender, _amountA, _amountB);
    }

    function swapDaiLink(uint256 _amountA) external {
        require(msg.sender != address(0), "address zero detected");
        require(_amountA > 0, "Can't exchange zero amount");
        require(dai.balanceOf(msg.sender) >= _amountA, "Insufficient Balance");
        uint _amountB = uint(getDerivedPrice(dai_usd, link_usd, 18));
        require(link.balanceOf(address(this)) >= _amountB, "Not enough tokenB");
        dai.transferFrom(msg.sender, address(this), _amountA);
        link.transfer(msg.sender, _amountB);
        emit SwapSuccessful(msg.sender, _amountA, _amountB);
    }

    function swapDaiEth(uint256 _amountA) external {
        require(msg.sender != address(0), "address zero detected");
        require(_amountA > 0, "Can't exchange zero amount");
        require(dai.balanceOf(msg.sender) >= _amountA, "Insufficient Balance");
        uint _amountB = uint(getDerivedPrice(dai_usd, eth_usd, 18));
        require(weth.balanceOf(address(this)) >= _amountB, "Not enough tokenB");
        dai.transferFrom(msg.sender, address(this), _amountA);
        weth.transfer(msg.sender, _amountB);
        emit SwapSuccessful(msg.sender, _amountA, _amountB);
    }

    function getDerivedPrice(
        AggregatorV3Interface _base,
        AggregatorV3Interface _quote,
        uint8 _decimals
    ) public view returns (int256) {
        require(
            _decimals > uint8(0) && _decimals <= uint8(18),
            "Invalid _decimals"
        );
        int256 decimals = int256(10 ** uint256(_decimals));
        (, int256 basePrice, , , ) = _base.latestRoundData();
        uint8 baseDecimals = _base.decimals();
        basePrice = scalePrice(basePrice, baseDecimals, _decimals);
        (, int256 quotePrice, , , ) = _quote.latestRoundData();
        uint8 quoteDecimals = _quote.decimals();
        quotePrice = scalePrice(quotePrice, quoteDecimals, _decimals);
        return (basePrice * decimals) / quotePrice;
    }

    function scalePrice(
        int256 _price,
        uint8 _priceDecimals,
        uint8 _decimals
    ) internal pure returns (int256) {
        if (_priceDecimals < _decimals) {
            return _price * int256(10 ** uint256(_decimals - _priceDecimals));
        } else if (_priceDecimals > _decimals) {
            return _price / int256(10 ** uint256(_priceDecimals - _decimals));
        }
        return _price;
    }
}
