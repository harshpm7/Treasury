# Treasury
A treasury contract which will stake funds with different Lending Protocols in a specific ratio

As mentioned in the problem statement, we will consider a dummy Liquidity provider platform for example and here will describe the functions and parameters required and used in the treasury smart contract. The steps are as follows:
* The deployer, post deploying the contract, will set the ratio for swapping the tokens. The function will be like:
```function setRatio(uint256 _ratio, address _token) external onlyOwner```
* The user deposits funds into the smart contract.
* The funds deposited by the user will be swapped based on the ratio set by the deployer.
* Post swapping the funds will be staked in particular defi protocols
* The user can also check the yield they earn 
* The contract can withdraw funds as a whole or partially as well.
* The user can also withdrar the funds deposited, partially and as a whole as well
* Apart from this there are 3 functions to check the balances, i.e., check the USDC balance in a contract, check the user's balance and check the staked balance.
## Flow Diagram:
![Treasury contract flow](https://user-images.githubusercontent.com/51759035/235348086-e8858643-2f33-4ecd-94a8-355a7e6687db.jpg)
