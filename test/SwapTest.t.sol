// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/Swap.sol";
import "../src/ISwap.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract CounterTest is Test {
    ISwap public swap;
    IERC20 dai;
    IERC20 link;
    IERC20 eth;

    address userAddrForEth =
        address(0x477b144FbB1cE15554927587f18a27b241126FBC);
    address userAddrForDai =
        address(0xe902aC65D282829C7a0c42CAe165D3eE33482b9f);
    address userAddrForLink =
        address(0x6a37809BdFC0aC7b73355E82c1284333159bc5F0);

    function setUp() public {
        dai = IERC20(0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357);
        link = IERC20(0xf8Fb3713D459D7C1018BD0A49D19b4C44290EBE5);
        eth = IERC20(0xb16F35c0Ae2912430DAc15764477E179D9B9EbEa);
        swap = ISwap(0x2564310e6D13AbDA605bBa0bd5aD347B4d5cB3a5);
    }

    function testingSwapEthDai() public {
        switchSigner(userAddrForDai);
        uint256 balance = dai.balanceOf(userAddrForDai);
        dai.transfer(address(swap), balance);

        switchSigner(userAddrForEth);
        uint balanceOfDaiBeforeSwap = dai.balanceOf(userAddrForEth);
        eth.approve(address(swap), 4);
        swap.swapEthDai(4);
        uint balanceOfDaiAfterSwap = dai.balanceOf(userAddrForEth);

        assertGt(balanceOfDaiAfterSwap, balanceOfDaiBeforeSwap);
        assertLt(balanceOfDaiBeforeSwap, balanceOfDaiAfterSwap);
    }

    function testingSwapEthLink() public {
        switchSigner(userAddrForLink);
        uint256 balance = link.balanceOf(userAddrForLink);
        link.transfer(address(swap), balance);

        switchSigner(userAddrForEth);
        uint balanceOfLinkBeforeSwap = link.balanceOf(userAddrForEth);
        eth.approve(address(swap), 3);
        console.log("balanceOfLinkBeforeSwap", balanceOfLinkBeforeSwap);
        swap.swapEthLink(3);
        uint balanceOflinkAfterSwap = link.balanceOf(userAddrForEth);

        assertGt(balanceOflinkAfterSwap, balanceOfLinkBeforeSwap);
        assertLt(balanceOfLinkBeforeSwap, balanceOflinkAfterSwap);
    }

    function testingSwapLinkDai() public {
        switchSigner(userAddrForDai);
        uint256 balance = dai.balanceOf(userAddrForDai);
        dai.transfer(address(swap), balance);

        switchSigner(userAddrForLink);
        uint balanceOfDaiBeforeSwap = dai.balanceOf(userAddrForLink);
        link.approve(address(swap), 5);
        swap.swapLinkDai(5);
        uint balanceOfDaiAfterSwap = dai.balanceOf(userAddrForLink);

        assertGt(balanceOfDaiAfterSwap, balanceOfDaiBeforeSwap);
        assertLt(balanceOfDaiBeforeSwap, balanceOfDaiAfterSwap);
    }

    function testingSwapLinkEth() public {
        switchSigner(userAddrForEth);
        uint256 balance = eth.balanceOf(userAddrForEth);
        eth.transfer(address(swap), balance);

        switchSigner(userAddrForLink);
        uint balanceOfLinkBeforeSwap = eth.balanceOf(userAddrForLink);
        link.approve(address(swap), 7);
        swap.swapLinkEth(7);
        uint balanceOfLinkAfterSwap = eth.balanceOf(userAddrForLink);

        assertGt(balanceOfLinkAfterSwap, balanceOfLinkBeforeSwap);
        assertLt(balanceOfLinkBeforeSwap, balanceOfLinkAfterSwap);
    }

    function testingSwapDaiLink() public {
        switchSigner(userAddrForLink);
        uint256 balance = link.balanceOf(userAddrForLink);
        link.transfer(address(swap), balance);
        switchSigner(userAddrForDai);
        uint balanceOfLinkBeforeSwap = link.balanceOf(userAddrForDai);
        dai.approve(address(swap), 2);
        swap.swapDaiLink(2);
        uint balanceOfLinkAfterSwap = link.balanceOf(userAddrForDai);

        assertGt(balanceOfLinkAfterSwap, balanceOfLinkBeforeSwap);
        assertLt(balanceOfLinkBeforeSwap, balanceOfLinkAfterSwap);
    }

    function testingSwapDaiEth() public {
        switchSigner(userAddrForEth);
        uint256 balance = eth.balanceOf(userAddrForEth);
        eth.transfer(address(swap), balance);

        switchSigner(userAddrForDai);
        uint balanceOfEthBeforeSwap = eth.balanceOf(userAddrForDai);
        dai.approve(address(swap), 6);
        swap.swapDaiEth(6);
        uint balanceOfEthAfterSwap = eth.balanceOf(userAddrForDai);

        assertGt(balanceOfEthAfterSwap, balanceOfEthBeforeSwap);
        assertLt(balanceOfEthBeforeSwap, balanceOfEthAfterSwap);
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }

    function switchSigner(address _newSigner) public {
        address foundrySigner = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
        if (msg.sender == foundrySigner) {
            vm.startPrank(_newSigner);
        } else {
            vm.stopPrank();
            vm.startPrank(_newSigner);
        }
    }
}
