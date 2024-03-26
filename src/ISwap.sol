// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ISwap {
    function swapEthLink(uint256 _amountA) external;

    function swapEthDai(uint256 _amountA) external;

    function swapLinkEth(uint256 _amountA) external;

    function swapLinkDai(uint256 _amountA) external;

    function swapDaiEth(uint256 _amountA) external;

    function swapDaiLink(uint256 _amountA) external;
}
