// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TeamWallet {
    address public deployer;
    bool public walletSet=false;
    address[] public winningMembers;
    uint256 public totalCredits;

    // to store the transaction
    struct Transaction{
        address sender;
        uint256 amount;
        bool approved;
        string approvalStatus;
    }

    Transaction[] public transactions;

    // mapping(address=>mapping(uint256=>bool)) public approvalStatus;
    constructor()
    {
        deployer=msg.sender;
    }

    //For setting up the wallet
    function setWallet(address[] memory members, uint256 Credits) public {
        require(members.length>0,"The member should not be empty");
        require(Credits>0,"The winning credits should be greater than 0");
        bool deployerNotAMember=true;
        for(uint256 i=0;i<members.length;i++)
        {
            if(members[i]==deployer)
            {
                deployerNotAMember=false;
            }
        }
        require(deployerNotAMember,"The deployer should not be a memeber");
        require(walletSet==false,"The wallet is already set cant set again");
        winningMembers=members;
        totalCredits=Credits;
        walletSet=true;
    }

    //For spending amount from the wallet
    function spend(uint256 amount) public {
        require(walletSet,"The wallet is not set yet");
        require(amount>0,"The amount should be greater than 0");
        bool isTeamMember=false;
        for(uint256 i=0;i<winningMembers.length;i++)
        {
            if(winningMembers[i]==msg.sender)
            {
                isTeamMember=true;
                break;
            }
        }
        require(isTeamMember,"the request can only be apporved by a team member");
        Transaction memory newTransaction=Transaction({
            sender:msg.sender,
            amount:amount,
            approved:false,
            approvalStatus:"pending"
        });
        transactions.push(newTransaction);
    }

    //For approving a transaction request
    function approve(uint256 n) public {
       require(walletSet,"Wallet is not set");
       require(n<transactions.length,"Invalid transaction");
       bool isTeamMember=false;
       for(uint256 i=0;i<winningMembers.length;i++)
       {
        if(winningMembers[i]==msg.sender)
        {
            isTeamMember=true;
            break;
        }
       } 
       require(isTeamMember,"Only winning team members can be approved");
       require((keccak256(abi.encodePacked(transactions[n].approvalStatus)) == keccak256(abi.encodePacked("debited")) || keccak256(abi.encodePacked(transactions[n].approvalStatus)) == keccak256(abi.encodePacked("rejected"))), "Transaction cannot be processed");
       transactions[n].approved=true;
       if(totalCredits>transactions[n].amount)
       {
        totalCredits-=transactions[n].amount;
        transactions[n].approvalStatus="debited";
       }
       else
       {
        transactions[n].approvalStatus="failed";
       }
       
    //    approvalStatus[msg.sender][n]=true;
    }

    //For rejecting a transaction request
    function reject(uint256 n) public {
       require(walletSet,"Wallet is not set");
       require(n<transactions.length,"Invalid transaction");
       bool isTeamMember=false;
       for(uint256 i=0;i<winningMembers.length;i++)
       {
        if(winningMembers[i]==msg.sender)
        {
            isTeamMember=true;
            break;
        }
       } 
       require(isTeamMember,"Only winning team members can be approved");
       require(!(keccak256(abi.encodePacked(transactions[n].approvalStatus)) == keccak256(abi.encodePacked("debited")) || keccak256(abi.encodePacked(transactions[n].approvalStatus)) == keccak256(abi.encodePacked("rejected"))), "Transaction is already approved");
       transactions[n].approvalStatus="rejected";
    }

    //For checking remaing credits in the wallet
    function credits() public view returns (uint256) {
        return totalCredits;
    }

    //For checking nth transaction status
    function viewTransaction(uint256 n) public view returns (uint amount,string memory status){
        require(n<transactions.length,"Inavlid transaction index");

        Transaction storage transaction=transactions[n];
        if(transaction.approved&&keccak256(abi.encodePacked(transactions[n].approvalStatus)) != keccak256(abi.encodePacked("failed")))
        {
            status="debited";
        }
        else if(!transaction.approved)
        {
            status="pending";
        }
        else{
            status="failed";
        }
        return (transaction.amount,status);
    }
    function transactionStats() public view returns (uint debitedCount, uint pendingCount, uint failedCount) {
        debitedCount = 0;
        pendingCount = 0;
        failedCount = 0;

        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].approved && keccak256(abi.encodePacked(transactions[i].approvalStatus)) != keccak256(abi.encodePacked("failed"))) {
                debitedCount++;
            } else if (!transactions[i].approved) {
                pendingCount++;
            } else {
                failedCount++;
            }
        }

        return (debitedCount, pendingCount, failedCount);
    }
}