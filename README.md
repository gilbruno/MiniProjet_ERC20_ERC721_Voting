## Deploy USDV on Sepolia

```shell
forge script script/DeployUsdvToken.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $SEPOLIA_PRIVATE_KEY
```

to simulate 

```shell
forge script script/DeployUsdvToken.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $SEPOLIA_PRIVATE_KEY --broadcast
```


## Mint USDV for a particular user


```shell
cast send 0x2aF3c4E3a6ee455294693B977a2D3DABf419B3B5 "mint(address,uint256)" 0xB63cE207B985e8508b17B5e8CF3900EF22C4e444 50000000 --rpc-url $SEPOLIA_RPC_URL --private-key $SEPOLIA_PRIVATE_KEY
```

if any issue with these commands, you can add : _--legacy_ options