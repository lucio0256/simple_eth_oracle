// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

import "@openzeppelin/contracts/access/Ownable.sol";


interface OracleInterface {
    function createRequest() external;
}

contract Consumer is Ownable {
    OracleInterface public oracle;
    uint256 public ethPrice;

    event PriceUpdated(uint _ethPrice);

    constructor() Ownable(msg.sender) {}

    function setOracle(address _oracle) external onlyOwner {
        oracle = OracleInterface(_oracle);
    }

    function getData() external {
        return oracle.createRequest();
    }

    function _callback(uint256 _ethPrice) external {
        require(msg.sender == address(oracle), "Not authorized");
        ethPrice = _ethPrice;
        emit PriceUpdated(_ethPrice);
    }


    

}