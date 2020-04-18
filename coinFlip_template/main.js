var web3 = new Web3(Web3.givenProvider);
var contractInstance;
var bet = null;
var val = null;
var queryId = null;
var playerAddress;
$(document).ready(function() {
    window.ethereum.enable().then(function(accounts){
        contractInstance = new web3.eth.Contract(abi, "0xE89781aC6BaFBAC911f5f48D63f20B82b830af87", {from: accounts[0]});
        console.log("hello world");
        playerAddress = accounts[0];
        console.log(contractInstance);
        console.log(playerAddress);
       
    });
    

    $("#0.5Ether").click(() =>{
        val = "0.5";
    });
    $("#1Ether").click(() => {
        val = "1";
    });
    $("#2Ether").click(() => {
        val = "2";
    });
    $("#head").click(() => {
        bet = 0;
    });
    $("#tail").click(() => {
        bet = 1;
    });
    $("#bet").click(doBet);


});



function doBet(){
  
    var config = {
        value: web3.utils.toWei(val, "ether")
    }

    contractInstance.methods.flip(bet).send(config).then(function(result){
        console.log(result);
          console.log(result.events.queryCreated.returnValues.queryId);
          queryId = result.events.queryCreated.returnValues.queryId;
          $("#result").text("waiting result.....;)");
    contractInstance.events.betResult({
        fromBlock: 0
    }, function(error, event){ console.log(event); })
    .on('data', function(event){
        console.log(event.returnValues.playerAddress); // same results as the optional callback above
        console.log(event.returnValues.message);
        if( queryId == event.returnValues.queryId){
            $("#result").text(event.returnValues.message);
            
        }
        
    });

    });
    
}