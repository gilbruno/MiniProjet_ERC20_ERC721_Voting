// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {console} from "forge-std/Script.sol";
import {UsdvToken} from "../src/UsdvToken.sol";
import {SdvNft} from "../src/SdvNft.sol";
import {DeploySdvNft} from "../script/DeploySdvNft.s.sol";


contract SdvTest is Test {

    address USER = makeAddr('USER');
    address USER2 = makeAddr('USER2');
    address ADMIN_COLLECTION_NFT = makeAddr('admin_NFT');
    address USDV_DEPLOYER = makeAddr('usdv_deployer');
    string USDV_NAME = 'USDV';
    string USDV_SYMBOL = 'USDV';
    uint8 DECIMALS = 6;
    uint INIT_SUPPLY = 500000 * 10 ** DECIMALS; 

    uint STARTING_ETH_BALANCE = 10 ether;

    string NFT_NAME = 'Sup De Vinci Nft';
    string NFT_SYMBOL = 'SdvNft';

    string TOKEN_URI = 'https://ipfs.io/ipfs/Qnehyywgwdglh36FGHxfgh788';

    SdvNft sdvNft;



    function setUp() public {
        vm.deal(USDV_DEPLOYER, STARTING_ETH_BALANCE);
        // NFT
        DeploySdvNft deploySdvNft = new DeploySdvNft();
        sdvNft = deploySdvNft.run();

    }

    function testDeployerOwnAllTheSupplyAfterDeplyment() public {
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

    /*** TEST NFTs */

    function testNftName() public view {
        string memory expectedName = NFT_NAME;
        string memory actualName = sdvNft.name();
        assertEq(expectedName, actualName);
    }   

    function testNonAdminCannotMintNft() public {
        SdvNft sdvNft_;
        vm.startPrank(ADMIN_COLLECTION_NFT);
        sdvNft_ = new SdvNft();
        vm.stopPrank();

        vm.startPrank(USER);
        vm.expectRevert();
        sdvNft_.mintNft(USER2, TOKEN_URI);
        vm.stopPrank();
    }

    function testAdminCanMintNft() public {
        SdvNft sdvNft_;
        vm.startPrank(ADMIN_COLLECTION_NFT);
        sdvNft_ = new SdvNft();
        sdvNft_.mintNft(USER2, TOKEN_URI);
        vm.stopPrank();
    }

    function testUserOwnsNftAfterMint() public {
        SdvNft sdvNft_;
        vm.startPrank(ADMIN_COLLECTION_NFT);
        sdvNft_ = new SdvNft();
        sdvNft_.mintNft(USER2, TOKEN_URI);
        vm.stopPrank();

        assertEq(sdvNft_.balanceOf(USER2), 1);
    }


}