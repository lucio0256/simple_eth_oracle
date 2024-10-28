// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Oracle is Ownable {
    mapping (address => bool) pendingRequests;
    event NewRequest(address from);

    constructor() Ownable(msg.sender) {}

    function createRequest() external {
        require(!pendingRequests[msg.sender], "Your request already pending");
        pendingRequests[msg.sender] = true;
        emit NewRequest(msg.sender);
    }

    function setEthPrice(address _consumer, uint _price) external onlyOwner {
        require(pendingRequests[_consumer], "You are not in requests list");
        (bool success, ) = _consumer.call(abi.encodeWithSignature("_callback(uint256)", _price));
        require(success, "Error setting ethPrice");
        delete pendingRequests[_consumer];
    }
}
