// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract CampaignFactory {
    address payable[] public deployedCampaigns;
    string[] public name;
    string[] public description;

    function createCampaign(uint minimum,string memory camp_name,string memory camp_description) public {
        address newCampaign = address(new Campaign(minimum,camp_name,camp_description, msg.sender));
        deployedCampaigns.push(payable(newCampaign));
        name.push(camp_name);
        description.push(camp_description);
    }

    function getDeployedCampaigns() public view returns (address payable[] memory,string[] memory,string[] memory) {
        return (
            deployedCampaigns,
            name,
            description
        );
    }
}

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }

    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    string public campaign_name;
    string public campaign_description;
    mapping(address => bool) public approvers;
    uint public approversCount;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    constructor (uint minimum,string memory camp_name,string memory camp_description, address creator) {
        manager = creator;
        minimumContribution = minimum;
        campaign_name=camp_name;
        campaign_description=camp_description;

    }

    function contribute() public payable {
        require(msg.value > minimumContribution);
        if(approvers[msg.sender]==false)
        {
        approversCount++;
        approvers[msg.sender] = true;
        }
    }

    function createRequest(string memory description, uint value, address recipient) public restricted {
        Request storage newRequest = requests.push(); 
        newRequest.description = description;
        newRequest.value= value;
        newRequest.recipient= recipient;
        newRequest.complete= false;
        newRequest.approvalCount= 0;
    }

    function approveRequest(uint index) public {
        Request storage request = requests[index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];

        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        payable(request.recipient).transfer(request.value);
        request.complete = true;
    }
    
    function getSummary() public view returns (
      uint, uint, uint, uint, address
      ) {
        return (
          minimumContribution,
          address(this).balance,
          requests.length,
          approversCount,
          manager
        );
    }
    
    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }
}