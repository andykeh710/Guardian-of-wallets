pragma solidity >=0.5.0 <0.8.0;
// pragma experimental ABIEncoderV2;


// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title Social Recovery Wallet Smart Contract 
/// @author Mohammed El Amine Idmoussi / Yuling Ma 


// in save -
// send invitation to all guardians
// get ack
// choose random guardians
// send guardian list to user per request
// generate alias for stored seedpharse - match guardian's seedphrase with alias when requested later

// assign tokens to guardians
// =========================
// getGuardianFee
// ================

// in recovery -
// send recovery request to guardians
// get ack
// forward encrypted master key from user to guardians

contract Guardianwallet{

    struct Guardian {
        uint sequence;
        address guardianAddress;
        // string publicKey;
        bool ack;
    }

    string[] seedphrase; // seedphrase encrypted

    Guardian[] guardians; // potential guardians 

    Guardian[] randomGuardians; // chosen guardians


    // address alkemy = "0x4cbd09f249047dA75b95E170d85384f766874f28";

    
    address userAddress;

    uint private userAlias=100;
    string public inviteMessage;
    

  
    function sendInvitation(address _alkemy) public returns (string memory){
        string memory inviteMessage = "A Guardian is requested"  ;
        return inviteMessage;
    }

    function ackInvitation(uint id,address _alkemy) public {
        guardians.push(Guardian(id,_alkemy,false));
    } 

    function addAsRandomGuardian(uint _random) public  {
        require(_random < guardians.length);
        guardians[_random].ack = true;
        randomGuardians.push(guardians[_random]);
        
    }

    function getGuardian(uint index) public view returns (uint,address,bool){
        return (guardians[index].sequence,guardians[index].guardianAddress,guardians[index].ack);
    }
    
    function getRandomGuardians(uint index) public view returns (uint,address,bool){
        return (randomGuardians[index].sequence,randomGuardians[index].guardianAddress,randomGuardians[index].ack);
    }
    

    // chainlink 
     function getRandomNumber(uint chainlikNumber) public {
        //add the selected guardian 
        addAsRandomGuardian(chainlikNumber);
     }

     

    // function getRandomGuardians() public 
    //     returns(uint[] sequence, address[] guardianAddress){
    //         uint length = randomGuardians.length;
    //         uint[] memory seqs = new uint[](length);
    //         address[] guardAdrs = new address[](length);

    //         for(uint i=0; i<length; i++){
    //             Guardian storage g = randomGuardians[i];
    //             seqs[i] = g.sequence;
    //             guardAdrs[i] = g.guardianAddress;
    //         }

    //         return(seqs, guardAdrs);

    // }


    //no longer necessary as snippet is sent offline to guardians directly  --TBD
    function getSnippet() public returns (string memory, uint){
       for(uint i=0; i<randomGuardians.length; i++){
           uint ack1 = 100 + i;
           if (msg.sender == randomGuardians[i].guardianAddress){
               return (seedphrase[i], ack1);               
           }
       }
    }

//not necesaary - as will do in js  --tbd
    function ackSnippetForGuardian(string memory _ack) public returns (bool){
        for(uint i=0; i<randomGuardians.length; i++){
           if (msg.sender == randomGuardians[i].guardianAddress){
               //decrypt _ack with randomGuardians i's public key
               //hash ack1
               //compare ack1 with _ack
               //if match then true, else false
               string memory messageHash;//= web3.sha3(ack1);
               if (keccak256(bytes(messageHash)) == keccak256(bytes(_ack))){
                   return true;
               }else{
                   return false;
               }

           }
       }
    }

//not necessary as it'll be implemented in js --TBD
    function ackSnippetForUser(string memory _ack) public returns (bool){
        
           if (msg.sender == userAddress){
               //decrypt _ack with randomGuardians i's public key
               //hash ack1
               //compare ack1 with _ack
               //if match then true, else false
               string memory messageHash ="";// = web3.sha3(ack1);
               if (keccak256(bytes(messageHash)) == keccak256(bytes(_ack))){
                   return true;
               }else{
                   return false;
               }

           }
       
    }

    modifier isGuardian(){
        address caller = msg.sender;
        bool _isGuardian = false;
        for (uint i=0; i<guardians.length; i++){
            if (guardians[i].guardianAddress == caller){
                _isGuardian = true;
                break;
            }             
        }
        if (_isGuardian){
        _;
        }
    }

    modifier isRandomGuardian(){
        address caller = msg.sender;
        bool _isGuardian = false;
        for (uint i=0; i<randomGuardians.length; i++){
            if (randomGuardians[i].guardianAddress == caller){
                _isGuardian = true;
                break;
            }             
        }
        if (_isGuardian){
        _;
        }
    }

    modifier isUnAckGuardian(){
        address caller = msg.sender;
        bool _unAck = false;
        for (uint i=0; i<guardians.length; i++){
            if (guardians[i].guardianAddress == caller && !guardians[i].ack){                
                _unAck = true; 
                break;               
            }
        }
        if (_unAck){
            _;
        }
        
    }

    function getAliasForSeedphrase() public returns (uint){
        //hard code for network
        userAlias += 1; 
        return userAlias;
    }

    event RequestRecovery(uint _userAlias);
    // recovery request with 
    function requestRecovery(uint _a,  string memory publicKeys, string memory addresses) public returns (uint){
        emit RequestRecovery(_a);
        //for the test purpose tentative code 
        return _a;
    }

    // store contact list to ipfs
    // function storeContactList() public{
        // reauest master password from user
        // store it to ipfs
    // }
    
    // send fees to aave and issue a stake token
    // function earn() public{
    //     // earn interest from aave
    // }

    //receive(encrypted seedphrase) push the encrypted word into the  smart contract
    //getLis guardians(adresse , order) return the person adress to the user ? what is order? read from IPFS?
    //chos Guardian(number,adresses) chainlink to chose a random Guardian
    //sendSeedPhrase() send encrypted seedphrase to Guardian
    //storeContactList(adresse , order, randomMasterkey) store the Guardian contact list on ipfs ? what is order
    // encrypt(pubkey,word) general function   ?
    // earn GuardianAdress,amount) send money to aave to earn interest
    //

}