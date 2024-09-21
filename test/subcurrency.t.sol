// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/subcurrency.sol";

contract CoinTest is Test {
    Coin coin;
    address owner;
    address addr1;
    address addr2;

    function setUp() public {
        owner = address(this); // The contract itself will be the owner
        addr1 = address(0x1);
        addr2 = address(0x2);
        coin = new Coin();
    }

    function testDeployment() public {
        assertEq(coin.minter(), owner);
    }

    function testMint() public {
        coin.mint(addr1, 1000);
        assertEq(coin.balances(addr1), 1000);
    }

    function testFailMintNotOwner() public {
        vm.prank(addr1);
        coin.mint(addr1, 1000); // This should fail
    }

    function testSendTokens() public {
        coin.mint(addr1, 1000);

        vm.prank(addr1);
        coin.send(addr2, 500);

        assertEq(coin.balances(addr1), 500);
        assertEq(coin.balances(addr2), 500);
    }

    function testFailSendInsufficientBalance() public {
        coin.mint(addr1, 1000);

        vm.prank(addr1);
        coin.send(addr2, 500);

        vm.prank(addr1);
        vm.expectRevert("Insufficient amount of token");
        coin.send(addr2, 1000); // This should fail
    }
}
