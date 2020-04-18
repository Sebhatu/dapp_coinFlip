//import "./Ownable.sol";
pragma solidity >0.5.8 <0.6.5;
import "./Ownable.sol";
import "./provableAPI_0.6.sol";
contract CoinFlip is  Ownable, usingProvable{

  uint256 constant NUM_RANDOM_BYTES_REQUESTED = 1;


  struct Bet {
        address payable playerAddress;
        uint value;
        uint bet;
        uint queryIdInt;
    }
      event betResult(string message, address playerAddress, uint queryIdInt);
      event queryCreated(uint queryId);
     mapping (bytes32 => Bet) private bets;


     function flip(uint betOn) public payable {
       uint256 QUERY_EXECUTION_DELAY = 0;
       uint256 GAS_FOR_CALLBACK = 200000;
       bytes32 queryId = provable_newRandomDSQuery(
        QUERY_EXECUTION_DELAY,
        NUM_RANDOM_BYTES_REQUESTED,
        GAS_FOR_CALLBACK);
        uint val = msg.value;
        uint queryIdInt = uint(queryId);

        createBet(msg.sender,val,betOn,queryId,queryIdInt);
         emit queryCreated(queryIdInt);

     }
    function __callback(bytes32 _queryId, string memory _result, bytes memory _proof) public override{
         require(msg.sender == provable_cbAddress());

         uint randomNumber = uint(keccak256(abi.encodePacked(_result))) % 2;
         checkResult(_queryId,randomNumber);
    }

    function createBet(address payable add, uint val, uint bet, bytes32 queryId, uint queryIdInt) private {

      Bet memory newBet;
      newBet.playerAddress = add;
      newBet.value = val;
      newBet.bet = bet;
      newBet.queryIdInt = queryIdInt;

      insertBet(newBet,queryId);


    }

     function insertBet(Bet memory newBet, bytes32 queryId) private {
       bets[queryId] = newBet;
    }

    function checkResult(bytes32 queryId, uint randomNumber) private {
      string memory message;
       uint playerBetOn = bets[queryId].bet;

       if(playerBetOn == randomNumber){
         message = "You won";
            address payable playerAddress = bets[queryId].playerAddress;
            uint reward = bets[queryId].value * 2;
              playerAddress.transfer(reward);
       }else{
         message = "You lose";
       }
        uint queryIdInt = uint(queryId);
       emit betResult(message, bets[queryId].playerAddress,queryIdInt);

    }



}