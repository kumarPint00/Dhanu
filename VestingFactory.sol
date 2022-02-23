pragma solidity ^0.8.0;
contract VestingFactory is Ownable {
    
    event VestingCreated(address vestingContractAddress, address beneficiary);
    
    uint256 public constant START  = 1618707600; // start time 1618707600
    
    uint256 public constant CLIFF  = 86400 * 30; //30 days
    
    uint256 public constant DURATION  = 86400 * 180; //180 days
    
    uint256 public _usdcPrice = 150 * 1e4; // 1.5 USD 
    
    address public constant DHANU = address(0xFde0C3CBA0426EA642Cb9552893A5ceC33Ee7948); // DHANU TOKEN 0xd0345D30FD918D7682398ACbCdf139C808998709
    
    address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48); //USDC 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
    
    
    function purchaseWithUSDC(uint256 amount) public {
        uint256 cost = SafeMath.mul(amount, _usdcPrice);
        
        IDhanu(USDC).transferFrom(msg.sender, address(this), cost);
        DhanuVesting newVestingContract =new DhanuVesting(msg.sender, START, CLIFF, DURATION, false); // IRREVOCCABLE. Meaning, once vested, the tokens stay vested. There's no admin function to cancel it midway.
        IDhanu(DHANU).transfer(address(newVestingContract), SafeMath.mul(amount, 1e18));
        VestingCreated(address(newVestingContract), msg.sender);
    }
    
    function changePrice(uint256 price) onlyOwner public {
        _usdcPrice = price;
    }
    
    function withdraw(address payable) onlyOwner public returns(uint256) {
        uint balance = address(this).balance;
        msg.sender.transfer(balance);
    }
    
    function withdrawUSDC() onlyOwner public {
        uint balance = IDhanu(USDC).balanceOf(address(this));
        IDhanu(USDC).transfer(msg.sender, balance);
    }
    
    function withdrawDHANU() onlyOwner public {
        uint balance = IDhanu(DHANU).balanceOf(address(this));
        IDhanu(DHANU).transfer(msg.sender, balance);
    }
    
}