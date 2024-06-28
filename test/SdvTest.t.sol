// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {console} from "forge-std/Script.sol";
import {UsdvToken} from "../src/UsdvToken.sol";

contract SdvTest is Test {

    address USER = makeAddr('USER');
    address USER2 = makeAddr('USER2');
    address USDV_DEPLOYER = makeAddr('usdv_deployer');
    string USDV_NAME = 'USDV';
    string USDV_SYMBOL = 'USDV';
    uint8 DECIMALS = 6;
    uint INIT_SUPPLY = 500000 * 10 ** DECIMALS; 

    uint STARTING_ETH_BALANCE = 10 ether;

    function setUp() public {
        vm.deal(USDV_DEPLOYER, STARTING_ETH_BALANCE);

    }

    function testDeployerOwnAllTheSupplyAfterDeplyment() public {
        uint balanceOwnerBefore = USDV_DEPLOYER.balance;

        UsdvToken usdvToken;
        vm.startPrank(USDV_DEPLOYER);
        usdvToken = new UsdvToken(USDV_NAME, USDV_SYMBOL, INIT_SUPPLY);
        vm.stopPrank();

        uint balanceOwnerAfter = USDV_DEPLOYER.balance;
        uint balanceOwnerAfterInUsdv = usdvToken.balanceOf(USDV_DEPLOYER);
        console.log('TOTAL SUPPLY : ', usdvToken.totalSupply());
        console.log('BALANCE DEPLOYER : ', balanceOwnerAfter);
        assertEq(balanceOwnerAfterInUsdv, usdvToken.totalSupply());
    }

    function testOnlyDeployerCanMint() public {
        UsdvToken usdvToken;
        vm.startPrank(USDV_DEPLOYER);
        usdvToken = new UsdvToken(USDV_NAME, USDV_SYMBOL, INIT_SUPPLY);
        console.log('TOTAL SUPPLY AVANT : ', usdvToken.totalSupply());
        usdvToken.mint(USER, 1000);
        vm.stopPrank();
        console.log('TOTAL SUPPLY : ', usdvToken.totalSupply());
    }

    function testCanNotMintAboveTheMaxSupply() public {
        UsdvToken usdvToken;
        vm.startPrank(USDV_DEPLOYER);
        usdvToken = new UsdvToken(USDV_NAME, USDV_SYMBOL, INIT_SUPPLY);
        console.log('TOTAL SUPPLY AVANT : ', usdvToken.totalSupply());
        vm.expectRevert();
        usdvToken.mint(USER, usdvToken.MAX_SUPPLY()*2);
        vm.stopPrank();
        //console.log('TOTAL SUPPLY : ', usdvToken.totalSupply());
    }

    function testOnlyDeployerCanMint2() public {
        UsdvToken usdvToken;
        vm.startPrank(USDV_DEPLOYER);
        usdvToken = new UsdvToken(USDV_NAME, USDV_SYMBOL, INIT_SUPPLY);
        vm.stopPrank();

        vm.startPrank(USER);
        vm.expectRevert();
        usdvToken.mint(USER2, 100);
        vm.stopPrank();
    }

}