// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Vault.sol";

contract VaultTest is Test {
    Vault public vault;

    address user = makeAddr("user");

    function setUp() public {
        // Instantiate a new instance of the Vault contract
        vault = new Vault();

        // Fund the user with some ether using vm.deal
        vm.deal(user, 10 ether); // Provide user with 10 ether for testing
    }

    function testDeposit() public {
        // Prank user and call deposit with 1 ether
        vm.startPrank(user);
        vault.deposit{value: 1 ether}();
        vm.stopPrank();

        // Assert the user's balance in the vault is 1 ether
        assertEq(vault.balances(user), 1 ether);
    }

    function testWithdraw() public {
        // Prank user, deposit 2 ether, and withdraw 1 ether
        vm.startPrank(user);
        vault.deposit{value: 2 ether}();
        vault.withdraw(1 ether);
        vm.stopPrank();

        // Assert the user's balance in the vault is 1 ether
        assertEq(vault.balances(user), 1 ether);
    }

    function test_RevertWithdrawMoreThanBalance() public {
        // Prank user and deposit 1 ether
        vm.startPrank(user);
        vault.deposit{value: 1 ether}();

        // Expect the transaction to revert
        vm.expectRevert();

        // Try to withdraw 2 ether
        vault.withdraw(2 ether);

        vm.stopPrank();
    }

    function testGetBalance() public {
        // Prank user, deposit 0.5 ether, and check getBalance
        vm.startPrank(user);
        vault.deposit{value: 0.5 ether}();
        uint256 balance = vault.getBalance();
        vm.stopPrank();

        // Assert the returned balance is 0.5 ether
        assertEq(balance, 0.5 ether);
    }
}
