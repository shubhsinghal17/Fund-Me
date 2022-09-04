//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./PriceConverter.sol";
error NotOwner();
contract FundMe {
        using PriceConverter for uint256;
address public immutable owner;
constructor() {
owner = msg.sender;
}
uint256 public constant MinimumUsd = 50 * 1e18;
address[] public funders;
mapping (address => uint256) public addressToAmountFunded;

function fund() public payable {
require(msg.value.getConversionRate() >= MinimumUsd,"Did not send enough!");
funders.push(msg.sender);
  addressToAmountFunded[msg.sender] = msg.value;
}

modifier onlyOwner {
if (msg.sender != owner){revert NotOwner();}
_;
}

function withdraw() onlyOwner payable public {

for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){

address funder = funders[funderIndex];
addressToAmountFunded[funder] = 0;
}
funders = new  address[](0);

(bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
require(callSuccess,"call failed");
}
receive() external payable{
  fund();
}
fallback() external payable{
  fund();
}

}
