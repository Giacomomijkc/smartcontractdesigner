// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract smartContractGeneratorForDesigner {

    // versione 0, statica, 
    // il designer inizializza il contratto attraverso il costruttore impostando i parametri base del contratto
    /* al momento la dinamica di utilizzo dovrebber funzionare così:
    c'è un sito web a cui il designer si logga con suo wallet
    qui vede i parametri del contratto da settare e tramite bottone inizializza il costruttore
    il cliente si logga con wallet al medesimo sito e vede le condizioni del contratto
    può usare le funzioni per depositare/approvare/chiedere/rework/sospendere collaborazione
    il designer vede (trovare il modo di notificargli l'avviso) cambiare lo status delle variabili 
    conditionsApproved/limitRework/depositDone/balanceOf e di conseguenza fa o non fa le sue attività
    una volta sospesa o approvato il progetto lo smart contract dovrebbe distruggersi
    lo smart contract non ha ancora la funzione collegata di mintare il lavoro una volta approvato
    */

    // variabili contratto
    // come si possono aggiungere e gestire variabili di tempo (data inizio/data fine) per consentire o meno funzioni?

    uint public value; //come si fa a rendere questa variabile il valore ether che poi viene inviato?
    uint public limitOfRework;
    address payable public client;
    address payable public contractOwner; //perché se uso msg.sender (considerato che è sempre il designer ad inizializzare il contratto)?
    bool public conditionsApproved;
    bool public projectApproved;
    bool public depositDone;
    uint public balanceOf;
    address public contractAddress;

    
    
    constructor (uint _value, uint _limitOfRework, address payable _client, address payable _contractOwner){
            value = _value;
            limitOfRework = _limitOfRework;
            client = _client;
            contractOwner = _contractOwner;    
            address(this).balance;
            address(this);
        }

    receive() external payable {
    }

    // depositare il valore del contratto nello smart contract
    function depositByClient(uint256 deposit) public payable {
        require(msg.sender == client, "You are not the client");
        require(msg.value == deposit);
        deposit = msg.value;
        balanceOf += msg.value;
        depositDone = true;
    }

    
    //funzione per verificare il balance dello smart contract che contiene l'amount depositato

    function getBalance() public view returns (uint){
        return address(this).balance;
    }
    
    //funzione per approvare le condizioni da parte del cliente

    function approveConditions() public {
        require(msg.sender == client, "You are not the client");
        conditionsApproved = true;
    }

    //funzione per approvare il progetto, trasferisce amount all'artist

    function withdrawArtist() public payable returns (bool) {
        //require(value <= this.balance);
        require(msg.sender == client, "You are not the client");
        projectApproved = true;
        contractOwner.transfer(balanceOf);
        balanceOf -= balanceOf;
        return true;
    }

    function withdrawClient() public payable returns(bool) {
        //require(value <= this.balance);
        require(msg.sender == client, "You are not the client");
        client.transfer(balanceOf);
        balanceOf -= balanceOf;
        return true;
    }

    function reworkNeeded() public {
        require(msg.sender == client, "You are not the client");
        require(limitOfRework > 0, "Reworks limit exceeded");
        limitOfRework--;
    }
}