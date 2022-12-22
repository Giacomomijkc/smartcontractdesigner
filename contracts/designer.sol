// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract smartContractGeneratorForDesigner is Ownable, Pausable {

    //stati del contratto: proposto, proposta accettata, proposta rifiutata, lavoro pagato, lavoro riufiutato
    using SafeMath for uint256;
    enum DealState{
        OFFERED, OFFER_ACCEPTED, OFFER_DECLINED, DELIVERY_ACCEPTED, DELIVERY_DECLINED
    }

    struct Deal {
        uint256 dealValue;
        uint8 limitOfRework;
        address payable clientAddress;
        DealState status;
    }

    uint256 private balance;
    mapping (address => Deal[]) designersDeals;

    function receiveMoney() public payable {
        assert(msg.value.add(balance) >= balance);
        balance = balance.add(msg.value);
    }
    
    receive() external payable {
        receiveMoney();
    }

    function createDeal(uint256 _dealValue, uint8 _limitOfRework, address payable _clientAddress) public whenNotPaused {
        Deal memory _deal = Deal({
            dealValue: _dealValue, 
            limitOfRework: _limitOfRework,
            clientAddress: _clientAddress,
            status: DealState.OFFERED
        });
        
        //Deal[] memory _deals = designersDeals[msg.sender];
        //_deals.push(_deal);
        
        designersDeals[msg.sender].push(_deal);
    }  

    // depositare il valore del contratto nello smart contract
    /*function depositByClient(uint256 deposit) public payable {
        require(msg.sender == client, "You are not the client");
        require(msg.value == deposit);
        deposit = msg.value;
        balanceOf += msg.value;
        depositDone = true;
    }*/

    
    //funzione per verificare il balance dello smart contract che contiene l'amount depositato

    function getBalance() public view returns (uint){
        return address(this).balance;
    }
    
    //funzione per approvare le condizioni da parte del cliente

    /*function approveConditions() public {
        require(msg.sender == client, "You are not the client");
        conditionsApproved = true;
    }*/

    //funzione per approvare il progetto, trasferisce amount all'artist

    /*function withdrawArtist() public payable returns (bool) {
        //require(value <= this.balance);
        require(msg.sender == client, "You are not the client");
        projectApproved = true;
        contractOwner.transfer(balanceOf);
        balanceOf -= balanceOf;
        return true;
    }*/

    /*function withdrawClient() public payable returns(bool) {
        //require(value <= this.balance);
        require(msg.sender == client, "You are not the client");
        client.transfer(balanceOf);
        balanceOf -= balanceOf;
        return true;
    }*/

    /*function reworkNeeded() public {
        require(msg.sender == client, "You are not the client");
        require(limitOfRework > 0, "Reworks limit exceeded");
        limitOfRework--;
    }*/
}