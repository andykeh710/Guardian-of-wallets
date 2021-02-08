import { assert } from "chai";
var CryptoJS = require("crypto-js");
var RSAKey = require('react-native-rsa');

const GuardianContract =  artifacts.require("../contracts/Guardianwallet.sol");

contract('GuardianContract', function(accounts){
    
    it('End to End test for Guardian',async () => {
        let contract = await GuardianContract.deployed();
        console.log("======================= Protect Password =========================");
        // list of random Guardian
        const Alkemy = "0x4cbd09f249047dA75b95E170d85384f766874f28";
        const Guardian1 = [1,"0x0faec453AeEc4f09Eb3B8b2bD1783122a89B49C5"];
        const Guardian2 = [2,"0xf36fdB239a43192dC12dA3Dd5DE132dd145647B2"];

        // send invitation
        let invitation = await contract.sendInvitation(Alkemy);
        console.log("invitation has been sent succefully :) !!!");
        // assert.equal(invitation.valueOf,"A Guardian is requested");

        await contract.ackInvitation(1,Alkemy);
        console.log("Alkemy had accepted the invitation");

        console.log("================================================");

        console.log('Calling all Guardians in the Network');
        let index = 0;
        let guardian = await contract.getGuardian(index);
        console.log("my guardian sequence: ",guardian['0']['words'][0]);
        console.log("my guardian address: ",guardian['1']);
        console.log("my guardian state: ",guardian['2']);

        console.log("================================================");

        //choose random guardians
        console.log("Selecting Random Guardians");
        await contract.addAsRandomGuardian(index,{from: accounts[0]});
        let randomGuardian = await contract.getRandomGuardians(index);
        console.log("my chosen guardian sequence: ",randomGuardian['0']['words'][0]);
        console.log("my chosen guardian address: ",randomGuardian['1']);
        console.log("my chosen guardian state: ",randomGuardian['2']);

        console.log("================================================");

        // split the seedphrase
        var seedphrase = [ "witch","collapse","practice","feed","shame","open","despair","creek","road","again","ice","least"];
        let masterKey = "Alkemy@666";

        var data = [{ ref: 0, seedphrase: seedphrase[0] }];
        console.log("Seedphrase before encryption: ",JSON.stringify(data));
        // Encrypt
        var ciphertext = CryptoJS.AES.encrypt(JSON.stringify(data), masterKey).toString();
        //log encrypted data
        console.log("Seedphrase after encryption",ciphertext);

        console.log("encrypting with the guardian public key....");

        console.log("================================================");

        console.log("Sending your guardian list to ipfs");
        console.log("{alias:mohammed,guardian1:0x4cbd09f249047dA75b95E170d85384f766874f28,ref:789}");
        console.log("sending................................");

        console.log("================================================");

        console.log("the guardian had confirmed the password storage.")

    

        console.log("\n====================================================================================");
        console.log("====================================================================================\n");

        console.log("======================= Request Seedphrase =========================");
        
        // send invitation
        let invitation1 = await contract.sendInvitation(Alkemy);
        console.log("Calling your Guardians to retrive your password !!!");
        // assert.equal(invitation.valueOf,"A Guardian is requested");

        await contract.ackInvitation(1,Alkemy);
        console.log("Alkemy had accepted the invitation");

        console.log("================================================");

        console.log("sending your encrypted password to verify identity");
        console.log("indentity confirmed :)");

        let lastpass = "U2FsdGVkX19AxL4bur+28WBWeKOpzynzQzT2Q7nup91IOR7/GvLkTT6zcZSA+CdQHSZfh9yQlEO07ypd8qMu2w==";
        console.log("Decrypting your password localyc:",lastpass);
        // Decrypt
        var bytes = CryptoJS.AES.decrypt(ciphertext, masterKey);
        var decryptedData = JSON.parse(bytes.toString(CryptoJS.enc.Utf8));
        
        //log decrypted Data
        console.log("decrypted password: ",JSON.stringify(decryptedData));

        console.log("================================================");

        console.log("Sending your fund to the new wallet");
        console.log("sending................................");

        console.log("================================================")

    });

})

// scenario add password for one guardian :
// request add password
// get random guardian call sendinvitation()
// gardians answers accept ackinvitation()

// split the password js
// recieve info of guardians pubkey & order

// encrypt with pubkey
// input master key
// encrypt with master key
// store the contactlist
// store the final encrypted word

// scenario retreive :
// request password
// send the contact list
// sendInvitation
//accept invitation
// send the master key encrypted with each pubkey


