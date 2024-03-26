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

    function testSwapEthDai() public {
        switchSigner(userAddrForDai);
        uint256 balance = dai.balanceOf(userAddrForDai);
        dai.transfer(address(swap), balance);

        switchSigner(userAddrForEth);
        uint balanceOfDaiBeforeSwap = dai.balanceOf(userAddrForEth);
        eth.approve(address(swap), 1);

        swap.swapEthDai(1);

        uint balanceOfDaiAfterSwap = dai.balanceOf(userAddrForEth);

        assertGt(balanceOfDaiAfterSwap, balanceOfDaiBeforeSwap);
    }

    function testSwapEthLink() public {
        switchSigner(userAddrForLink);
        uint256 balance = link.balanceOf(userAddrForLink);
        link.transfer(address(swap), balance);

        switchSigner(userAddrForEth);
        uint balanceOfLinkBeforeSwap = link.balanceOf(userAddrForEth);
        eth.approve(address(swap), 1);
        console.log("balanceOfLinkBeforeSwap", balanceOfLinkBeforeSwap);
        swap.swapEthLink(1);

        uint balanceOflinkAfterSwap = link.balanceOf(userAddrForEth);

        assertGt(balanceOflinkAfterSwap, balanceOfLinkBeforeSwap);
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
