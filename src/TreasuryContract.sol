// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface IStaking {
    function deposit(address token, uint256 amount) external;
    function withdraw(address token, uint256 amount) external;
    function getAPY(address token, address user) external view returns(uint256);
    function getBalance(address token, address user) external view returns(uint256);
}

interface ISwapping {
    function swap(address _tokenIn, address _tokeOut, uint256 _amountIn) external;
}

contract TreasuryContract {

    mapping(address => uint256) userBalance;
    mapping(address => bool) isTokenWhitelisted;
    mapping(address => uint256) tokenRatio;
    uint256 totalRatio = 100;
    address owner;
    IERC20 USDC;
    IStaking lendingContract;
    ISwapping swappingContract;

    modifier onlyOwner {
        require(owner == msg.sender, "Sender is not the owner");
        _;
    }

    constructor(address _contractAddress, address _lendingContractAddress, address _swappingContractAddress) {
        USDC = IERC20(_contractAddress);
        owner =  msg.sender;
        lendingContract = IStaking(_lendingContractAddress);
        swappingContract = ISwapping(_swappingContractAddress);

    }

    function depositFunds(uint256 _amount) external payable {
        USDC.transferFrom(msg.sender, address(this), _amount);
        userBalance[msg.sender] += _amount;

    }

    function checkFunds() external view returns(uint256) {
        return(userBalance[msg.sender]);
    }

    function swapFunds(address _tokenIn, address _tokeOut) external {
        uint256 totalBalance = USDC.balanceOf(address(this));
        uint256 amountIn = (totalBalance * tokenRatio[_tokeOut])/totalRatio;
        swappingContract.swap(_tokenIn, _tokeOut, amountIn);
    }

    function setRatio(uint256 _ratio, address _token) external onlyOwner {
        if(_ratio == 0) {
            isTokenWhitelisted[_token] = false;
            tokenRatio[_token] = 0;
        } else {
            isTokenWhitelisted[_token] = true;
            tokenRatio[_token] = _ratio;
        }
    }

    function withdrawFunds(uint256 _amount) external {
        require(_amount <= userBalance[msg.sender], "Insufficient Funds");
        USDC.transferFrom(address(this), msg.sender, _amount);
    }

    function stakeFunds(uint256 _amount, address _token) external {
        USDC.approve(address(lendingContract), _amount);
        lendingContract.deposit(_token, _amount);
    }

    function withdrawStake(uint256 _amount, address _token) external {
        lendingContract.withdraw(_token, _amount);
    }

    function checkAPY(address _user, address _token) external view returns(uint256) {
        return lendingContract.getAPY(_token, _user);
    }

    function checkBalance(address _token) external view returns(uint256) {
        return IERC20(_token).balanceOf(address(this));
    }

    function checkUserBalance(address _user) external view returns(uint256) {
        return userBalance[_user];
    }

    function checkStakedBalance(address _user, address _token) external view returns(uint256) {
        return lendingContract.getBalance(_token, _user);
    }

} 